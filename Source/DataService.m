//
//  DataService.m
//  RACTest
//
//  Created by Petr Šíma on Mar/9/15.
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import "DataService.h"
#import <AFNetworking.h>
#import "Groot.h"
#import "GRTJSONSerialization+ReactiveCocoa.h"
#import <NSValueTransformer+TransformerKit.h>
#import <TTTDateTransformers.h>
#import <objc/runtime.h>
#import <Mantle.h>
#import <StandardPaths.h>

#pragma mark Request Filters
NSString *const kFilterOffsetKey = @"offset";
NSString *const kFilterLimitKey = @"limit";
NSString *const kFilterProjectIdKey = @"project_id";
NSString *const kFilterAssignedToIdKey = @"assigned_to_id";
NSString *const kFilterQueryIdKey =  @"query_id";

NSString *const kFilterFavoriteKey =  @"favorited";
NSString *const kFilterSetFiltertKey =  @"set_filter";
NSString *const kFilterStatusIdKey =  @"status_id";
NSString *const kFilterWatchIdKey =  @"watcher_id";
NSString *const kFilterLastUpdateOnKey =  @"last_updated_on";
NSString *const kFilterAuthorIdKey =  @"author_id";

#pragma mark -

#pragma mark uploadDictionary
NSString *const ProgressKey = @"progress";
NSString *const TokenKey = @"token";
NSString *const TotalBytesSentKey = @"bytes_sent";
NSString *const TotalBytesExpectedKey = @"bytes_expected";

#pragma mark -


@interface DataService() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate> {
}

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSValueTransformer *atomTransformer;
@property (nonatomic, assign) RMApiType apiType;

@property (nonatomic, strong) AFHTTPSessionManager *backgroundSessionManager;

@property (nonatomic, strong, readwrite) NSMutableDictionary *uploadDictionary;

@end

@implementation DataService

+(instancetype)sharedService
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [self new];
	});
}

NSString * const ReverseAtomDateTransformerName = @"ReverseAtomDateTransformer";
NSString * const RMDateTransformerName = @"RMDateTransformer";
NSString * const StringToNumberTransformerName = @"StringToNumberTransformer";
NSString * const WrapInArrayTransformerName = @"WrapInArrayTransformer";

-(instancetype)init
{
	if(self = [super init]){
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			NSValueTransformer *atomTransformer = [NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName];
			[NSValueTransformer registerValueTransformerWithName:ReverseAtomDateTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
				return [atomTransformer reverseTransformedValue:value];
			} allowingReverseTransformationWithBlock:^id(id value) {
				return [atomTransformer transformedValue:value];
			}];
			self.atomTransformer = [NSValueTransformer valueTransformerForName:ReverseAtomDateTransformerName];
			
			NSDateFormatter *rmDateFormatter = [NSDateFormatter new];
			rmDateFormatter.dateFormat = @"YYYY-MM-dd";
			NSDateFormatter *rmDateTimeFormatter = [NSDateFormatter new];
			rmDateTimeFormatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
			[NSValueTransformer registerValueTransformerWithName:RMDateTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(id value) {
				NSDate *d = [rmDateFormatter dateFromString:value];
				if(!d) d = [rmDateTimeFormatter dateFromString:value];
				return d;
			} allowingReverseTransformationWithBlock:^id(id value) {
				return [rmDateFormatter stringFromDate:value];
			}];
			static NSNumberFormatter *numberFormatter;
			numberFormatter = [[NSNumberFormatter alloc] init];
			[NSValueTransformer registerValueTransformerWithName:StringToNumberTransformerName transformedValueClass:[NSNumber class] returningTransformedValueWithBlock:^id(id value) {
				return [numberFormatter numberFromString:value];
			} allowingReverseTransformationWithBlock:^id(id value) {
				return [numberFormatter stringFromNumber:value];
			}];
			
			
			[NSValueTransformer registerValueTransformerWithName:WrapInArrayTransformerName transformedValueClass:[NSArray class] returningTransformedValueWithBlock:^id(id value) {
				if(![value isKindOfClass:[NSArray class]]){
					value = @[value];
				}
				return value;
			}];
		});
		
	}
	return self;
}

-(void)refreshBackgroundSession
{
	self.backgroundSessionManager = [self createBackgroundSessionManager];
	self.uploadDictionary = [NSMutableDictionary dictionary];
	
	[[[self getUploadTasks] flattenMap:^id(NSArray *value) {
		return [value.rac_sequence signal];
	}] subscribeNext:^(NSURLSessionUploadTask *task) {
		self.uploadDictionary[@([task taskIdentifier])] = [self progressAndCompletedSignalForTask:task];
	}];
	
}

-(NSDictionary *)progressAndCompletedSignalForTask:(NSURLSessionUploadTask *)task
{
		RACSignal * completedSignal = [self rac_signalForSelector:@selector(URLSession:task:didCompleteWithError:)];
		
		RACSignal * progressSignal = [self rac_signalForSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)];
		
		
		RACSignal *dataSignal = [self rac_signalForSelector:@selector(URLSession:dataTask:didReceiveData:)];
		
		
	RACSignal *taskCompletedSignal = [[[[completedSignal filter:^BOOL(RACTuple *args) {
			return [args.second taskIdentifier] == [task taskIdentifier];
	}] take:1]  flattenMap:^RACStream *(RACTuple *args) {
			if(args.third){
				return [RACSignal error:args.third];
			}else{
				return [RACSignal return:args.second];
			}
		}] replayLazily];
		RACSignal *taskDataSignal = [[[[dataSignal
												  takeUntil:taskCompletedSignal]
												 filter:^BOOL(RACTuple *args) {
													 return [args.second taskIdentifier] == [task taskIdentifier];
												 }] map:^id(RACTuple *args) {
													 return args.third;
												 }] aggregateWithStart:[NSMutableData data] reduce:^id(NSMutableData *running, NSData *next) {
													 [running appendData:next];
													 return running;
												 }];
		
		RACSignal *tokenSignal = [[[RACSignal combineLatest:@[taskDataSignal, taskCompletedSignal]] tryMap:^id(RACTuple *value, NSError *__autoreleasing *errorPtr) {
			NSDictionary *JSON = [self.backgroundSessionManager.responseSerializer responseObjectForResponse:[value.second response] data:value.first error:errorPtr];
			if(*errorPtr) return nil;
			NSString *token = [JSON valueForKeyPath:@"upload.token"];
			if(!token){
				assert(NO);
				(*errorPtr) = [NSError errorWithDomain:@"" code:0 userInfo:nil]; //shouldnt happen if JSON contains token as expected
			}
			return token;
		}] replayLazily];
	
	RACSignal *taskProgressSignal = [[[progressSignal
												  takeUntilReplacement:[tokenSignal ignoreValues]] //make progresssignal send same error/completed events as tokenSignal
												 filter:^BOOL(RACTuple *args) {
													 return [args.second taskIdentifier] == [task taskIdentifier];
												 }] map:^id(RACTuple *args) {
													 return @{TotalBytesSentKey : args.fourth, TotalBytesExpectedKey : args.fifth};
												 }];
	
		return @{ProgressKey : taskProgressSignal, TokenKey : tokenSignal};
}

-(RACSignal *)loginAndDownloadProjectsWithUserCredentials:(UserCredentials *)cred apiType:(RMApiType)type
{
	return [[[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) { // setup
		self.apiType = type;
		self.sessionManager =  [[AFHTTPSessionManager alloc] initWithBaseURL:cred.baseUrl];
		AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
		[policy setAllowInvalidCertificates:YES];
		self.sessionManager.securityPolicy = policy;
		self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
		[self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:cred.username password:cred.password];
		[self refreshBackgroundSession]; //TODO: find a proper place for this, if logged in, should find baseUrl in init method
		
		
		self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
		
		//global query string serialization block
		//maps key : arrayValue pairs to key=<comma_separated_string>
		//this behaviour should be globally expected by API, if its not, use default serialization behaviour and transform parameter dictionary before passing it to AFNetworking
		[self.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
			if([parameters isKindOfClass:[NSDictionary class]]){
				NSDictionary *dict = (id)parameters;
				return [[dict.rac_sequence map:^id(RACTuple *keyAndValue) {
					id key = keyAndValue.first;
					id val = keyAndValue.second;
					NSString *outValue;
					if([val isKindOfClass:[NSArray class]]){
						RACSequence *arrSeq = [val rac_sequence];
						return [NSString stringWithFormat:@"%@=%@", key, [arrSeq.tail foldLeftWithStart:[NSString stringWithFormat:@"%@", arrSeq.head] reduce:^id(NSString *accumulator, id value) {
							return [accumulator stringByAppendingString:[NSString stringWithFormat:@",%@", value]];
						}]];
					}else{
						outValue = [val description];
					}
					
					return [NSString stringWithFormat:@"%@=%@",key, outValue];
				}] foldLeftWithStart:@"" reduce:^id(id accumulator, id value) {
					return [NSString stringWithFormat:@"%@&%@", accumulator, value];
				}];
			}
			return @"";
		}];

		
		[subscriber sendCompleted];
		return nil;
	}] then:^RACSignal *{ //download global enumerations, TODO: do in parallel with download projects?
		return [RACSignal combineLatest:@[[[DataService sharedService] fetchQueries], [[DataService sharedService] fetchEnumerations]]]; //side effects, saves stuff to db
	}]
					
					then:^RACSignal *{
		return [self downloadProjectsWithOffset:0];
	}] collect]
		map:^id(NSArray *value) {
			return [[value.rac_sequence flattenMap:^RACStream *(id value) {
				return [value rac_sequence];
			}] array];
	}] doNext:^(NSArray *x) {
		NSManagedObjectContext *context = [x.firstObject managedObjectContext];
		[context MR_saveOnlySelfAndWait]; //merge changes to main thread context
	}] replayLazily];
}

-(RACSignal *)downloadProjectsWithOffset:(NSUInteger)offset
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

		NSDictionary *parameters = @{@"limit" : @(INT_MAX), @"offset" : @(offset)};

		NSURLSessionDataTask *task = [self.sessionManager GET:@"/projects.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			RMResponseMetadata *metadata = [RMResponseMetadata modelObjectWithDictionary:responseObject];
			NSArray *projectsJSON = responseObject[@"projects"];
			RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"Project" fromJSONArray:projectsJSON inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
			

			RACSignal *nextPageSignal = [RACSignal empty];
			NSUInteger nextOffset = metadata.offset + projectsJSON.count;
			if(metadata.totalCount > nextOffset){ //download another page
				nextPageSignal = [self downloadProjectsWithOffset:nextOffset];
			}
			[[thisPageSignal concat:nextPageSignal] subscribe:subscriber];
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			NSHTTPURLResponse *response = (id)task.response;
			
			[subscriber sendError:error];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

-(RACSignal *)fetchQueries
{
	RACSignal *fetch = self.apiType == RMApiTypeEasyRM ? [self easy_fetchQueriesWithFilter:nil] : [self rm_fetchQueriesWithFilter:nil];
	return [[[[[fetch
				  collect]
			  map:^id(NSArray *value) {
				  return [[value.rac_sequence flattenMap:^RACStream *(id value) {
					  return [value rac_sequence];
				  }] array];
			  }]
				 doNext:^(NSArray *x) {
				  [[x.firstObject managedObjectContext] MR_saveOnlySelfAndWait]; //merge to main thread context
			  }]
				deliverOn:[RACScheduler currentScheduler]] replayLazily];
}

-(RACSignal *)easy_fetchQueriesWithFilter:(NSDictionary *)filter
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSDictionary *parameters = [[self class] filterDictionaryByAddingDefaultValuesToDictionary:filter];
		NSURLSessionDataTask *task = [self.sessionManager GET:@"/easy_queries.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			RMResponseMetadata *metadata = [RMResponseMetadata modelObjectWithDictionary:responseObject];
			NSArray *queriesJSON = responseObject[@"easy_queries"];
			queriesJSON =  [queriesJSON.rac_sequence filter:^BOOL(NSDictionary *item) {
					return [item[@"type"] isEqualToString:@"EasyIssueQuery"];
			}].array;
			RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"Query" fromJSONArray:queriesJSON inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
			
			
			RACSignal *nextPageSignal = [RACSignal empty];
			NSUInteger nextOffset = metadata.offset + queriesJSON.count;
			NSUInteger currentLimit = [filter[kFilterLimitKey] unsignedIntegerValue];
			NSUInteger nextLimit = MAX(0, (NSInteger)currentLimit - (NSInteger)queriesJSON.count);
			if(nextLimit > 0 && metadata.totalCount > nextOffset){ //download another page
				NSMutableDictionary *nextFilter = [filter mutableCopy];
				nextFilter[kFilterOffsetKey] = @(nextOffset);
				nextFilter[kFilterLimitKey] = @(nextLimit);
				nextPageSignal = [self easy_fetchQueriesWithFilter:nextFilter];
			}
			[[thisPageSignal concat:nextPageSignal] subscribe:subscriber];
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			NSHTTPURLResponse *response = (id)task.response;
			
			[subscriber sendError:error];
		}];
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
	
}


-(RACSignal *)rm_fetchQueriesWithFilter:(NSDictionary *)filter
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSDictionary *parameters = [[self class] filterDictionaryByAddingDefaultValuesToDictionary:filter];
		NSURLSessionDataTask *task = [self.sessionManager GET:@"/queries.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			RMResponseMetadata *metadata = [RMResponseMetadata modelObjectWithDictionary:responseObject];
			NSArray *queriesJSON = responseObject[@"queries"];
			RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"Query" fromJSONArray:queriesJSON inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
			
			
			RACSignal *nextPageSignal = [RACSignal empty];
			NSUInteger nextOffset = metadata.offset + queriesJSON.count;
			NSUInteger currentLimit = [filter[kFilterLimitKey] unsignedIntegerValue];
			NSUInteger nextLimit = MAX(0, (NSInteger)currentLimit - (NSInteger)queriesJSON.count);
			if(nextLimit > 0 && metadata.totalCount > nextOffset){ //download another page
				NSMutableDictionary *nextFilter = [filter mutableCopy];
				nextFilter[kFilterOffsetKey] = @(nextOffset);
				nextFilter[kFilterLimitKey] = @(nextLimit);
				nextPageSignal = [self rm_fetchQueriesWithFilter:nextFilter];
			}
			[[thisPageSignal concat:nextPageSignal] subscribe:subscriber];
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			NSHTTPURLResponse *response = (id)task.response;

			[subscriber sendError:error];
		}];
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];

}

+(NSDictionary *)filterDictionaryByAddingDefaultValuesToDictionary:(NSDictionary *)dict
{
	NSDictionary *defaultDictionary = @{@"limit" : @(INT_MAX), @"offset" : @(0)};
	NSMutableDictionary *res = [NSMutableDictionary new];
	[res addEntriesFromDictionary:defaultDictionary];
	if(dict) {
		[res addEntriesFromDictionary:dict];
	}
	return [res copy];
}


-(RACSignal *)fetchIssuesWithFilter:(NSDictionary *)filter
{
	return [[[[self _fetchIssuesWithFilter:filter]
					collect]
			  map:^id(NSArray *value) {
				  return [[value.rac_sequence flattenMap:^RACStream *(id value) {
					  return [value rac_sequence];
				  }] array];
			  }]
				doNext:^(NSArray *x) { //persist
					id first = x.firstObject;
					if ([first isKindOfClass:[NSManagedObject class]]){
						[[first managedObjectContext] MR_saveToPersistentStoreAndWait];
					}
				}];
			//replayLazily]; //dont replay, so that we're able to cancel the task
}

-(RACSignal *)_fetchIssuesWithFilter:(NSDictionary *)filter
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSDictionary *parameters = [[self class] filterDictionaryByAddingDefaultValuesToDictionary:filter];
		
		NSURLSessionDataTask *task = [self.sessionManager GET:@"/issues.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			RMResponseMetadata *metadata = [RMResponseMetadata modelObjectWithDictionary:responseObject];
			NSArray *issuesJSON = responseObject[@"issues"];
			RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"Issue" fromJSONArray:issuesJSON inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
			
			
			RACSignal *nextPageSignal = [RACSignal empty];
			NSUInteger nextOffset = metadata.offset + issuesJSON.count;
			NSUInteger currentLimit = [filter[kFilterLimitKey] unsignedIntegerValue];
			NSUInteger nextLimit = MAX(0, (NSInteger)currentLimit - (NSInteger)issuesJSON.count);
			if(nextLimit > 0 && metadata.totalCount > nextOffset){ //download another page
				NSMutableDictionary *nextFilter = [filter mutableCopy];
				nextFilter[kFilterOffsetKey] = @(nextOffset);
				nextFilter[kFilterLimitKey] = @(nextLimit);
				nextPageSignal = [self _fetchIssuesWithFilter:nextFilter];
			}
			[[thisPageSignal concat:nextPageSignal] subscribe:subscriber];

		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			NSHTTPURLResponse *response = (id)task.response;
			
			[subscriber sendError:error];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];

}


-(RACSignal *)fetchDetailOfIssues:(Issue *)issue
{
	RACSignal *issueSignal = [self _fetchDetailOfIssueWithId:issue.identifier];
	RACSignal *relatedIssuesSignal = [issueSignal flattenMap:^RACStream *(Issue *value) {
		return [self downloadRelatedIssuesForRelations:[value.haveRelations allObjects]];
	}];
	RACSignal *issueSignalAfterDownloadingRelated = [relatedIssuesSignal then:^RACSignal *{
		return issueSignal;
	}];
	
	return [[[issueSignalAfterDownloadingRelated
              doNext:^(id x) { //persist
                  id first = x;
                  if ([first isKindOfClass:[NSManagedObject class]]){
                      [[first managedObjectContext] MR_saveToPersistentStoreAndWait];
                  }
              }]
             deliverOn:[RACScheduler currentScheduler]] replayLazily];;
}

-(RACSignal *)downloadRelatedIssuesForRelations:(NSArray *)relations //downloads all issues with issue_to_id's from 'relations'
{
 	return [[[[[[relations.rac_sequence map:^RACStream *(Relation *value) {
        
		return [self _fetchDetailOfIssueWithId:value.issueTo.identifier];
	}]
		signal] //convert seq to signal
					flatten]
			  collect]
             deliverOn:[RACScheduler currentScheduler]] replayLazily];; //collect results of signals into array;
}

-(RACSignal *)_fetchDetailOfIssueWithId:(NSNumber *)identifier
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		//pridal jsem querystring serialization block ktery umozni serializovat NSArray parameter do comma-separated stringu. Takze tohle by se melo spis delat jako parameters: @{@"include" : @[@"attachments", @"journals",...]}. Ale v tomhle pripade je to jedno.
        NSURLSessionDataTask *task = [self.sessionManager GET:[NSString stringWithFormat:@"/issues/%@.json?include=attachments,journals,children,relations",identifier ] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           // RMResponseMetadata *metadata = [RMResponseMetadata modelObjectWithDictionary:responseObject];
            NSMutableDictionary *issuesJSON = [responseObject[@"issue"] mutableCopy];
            
            [self updateGlobalJournalsOrderFromJSON:issuesJSON];
            RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectForEntityName:@"Issue" fromJSONDictionary:issuesJSON inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
			  
            [thisPageSignal subscribe:subscriber];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
         //   NSHTTPURLResponse *response = (id)task.response;
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


-(RACSignal *)fetchEnumerations
{
	if(self.apiType == RMApiTypeEasyRM){
		return [self _fetchTimeEntries];
	}else{
		return [[RACSignal combineLatest:@[[self _fetchTimeEntries], [self _fetchIssuePriorities]]]
				  replayLazily];
	}
}

-(RACSignal *)_fetchIssuePriorities
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		//NSDictionary *parameters = [[self class] filterDictionaryByAddingDefaultValuesToDictionary:filter];
		
		NSURLSessionDataTask *task = [self.sessionManager GET:@"/enumerations/issue_priorities.json"  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
			
			NSArray *prioritiesJSON = responseObject[@"issue_priorities"];
			RACSignal *prioritiesSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"Priority" fromJSONArray:prioritiesJSON inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
			
			[prioritiesSignal subscribe:subscriber];
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			//   NSHTTPURLResponse *response = (id)task.response;
			
			[subscriber sendError:error];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

-(RACSignal *)_fetchTimeEntries
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		 
        //NSDictionary *parameters = [[self class] filterDictionaryByAddingDefaultValuesToDictionary:filter];
        
        NSURLSessionDataTask *task = [self.sessionManager GET:@"/enumerations/time_entry_activities.json"  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *timeEntriesJSON = responseObject[@"time_entry_activities"];
            RACSignal *thisPageSignal = [GRTJSONSerialization rac_mergeObjectsForEntityName:@"TimeEntryActivity" fromJSONArray:timeEntriesJSON inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
            
			
            
            RACSignal *nextPageSignal = [RACSignal empty];
            
            [[thisPageSignal concat:nextPageSignal] subscribe:subscriber];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //   NSHTTPURLResponse *response = (id)task.response;
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}



-(void) updateGlobalJournalsOrderFromJSON:(NSDictionary *)JSON
{
    NSArray *journals = [JSON objectForKey:@"journals"];
    if ([journals count] >= 2) {
       id firstJournalDate = [journals[0] objectForKey:@"created_on"];
       id secondJournalDate = [journals[1] objectForKey:@"created_on"];
        
        if(firstJournalDate && secondJournalDate){
            NSDate *first = [self.atomTransformer transformedValue:firstJournalDate];
            NSDate *second = [self.atomTransformer transformedValue:secondJournalDate];
    
            if ([first compare:second] == NSOrderedDescending) {
                [UserDefaults setBool:NO forKey:kJournalOrderAsc];
            } else {
                [UserDefaults setBool:YES forKey:kJournalOrderAsc];
            }
            [UserDefaults synchronize];
        }
    }
}

-(RACSignal *)serializeIssue:(EditedIssue *)issue //cant use default groot serialization because format isnt same as GET /issues/{id}.json, TODO: extend groot to support multiple mappings
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

		NSError *error;
		NSMutableDictionary *dict = [[MTLJSONAdapter JSONDictionaryFromModel:issue error:&error] mutableCopy];
		NSValueTransformer *dateTransformer = [NSValueTransformer valueTransformerForName:RMDateTransformerName];
		if(issue.customFields.count > 0){
			NSArray *customFields = [[issue.customFields.rac_sequence filter:^BOOL(id cf) {
				return ![cf[@"field_format"] isEqualToString:@"datetime"];
			}] map:^id(id cf) {
				cf = [cf mutableCopy]; //dont change values of the original cf
				id value = cf[@"value"];
				if(cf[@"multiple"] && ![value isKindOfClass:[NSNull class]] && [cf[@"multiple"] boolValue] == NO){
//					assert([value isKindOfClass:[NSArray class]] && [value count] == 1);
					value = [value firstObject];
				}
				if([cf[@"field_format"] isEqualToString:@"date"]){
					value = [dateTransformer reverseTransformedValue:value];
				}else if ([value respondsToSelector:@selector(stringValue)]){
					value  = [value stringValue];
				}
				if(value){
					cf[@"value"] = value;
				}
				
				return cf;
			}].array;
			dict[@"custom_fields"] = customFields;
		}
		if(error){
			[subscriber sendNext:error];
		}else{
			NSDictionary *resultJSON = @{@"issue" : dict};
			
			[subscriber sendNext:resultJSON];
			[subscriber sendCompleted];
		}
		
		
		return nil;
	}];
}

-(RACSignal *)createIssue:(EditedIssue *)issue
{
	return [[[[self serializeIssue:issue] flattenMap:^RACStream *(id value) {
		return [self createIssueWithJSON:value];
	}] doNext:^(id x) {
		if([x isKindOfClass:[NSManagedObject class]]){
			[[x managedObjectContext] MR_saveToPersistentStoreAndWait];
		}
	}]
			  replayLazily];
}


-(RACSignal *)createIssueWithJSON:(NSDictionary *)issueJSON
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSURLSessionDataTask *task = [self.sessionManager POST:@"/issues.json" parameters:issueJSON success:^(NSURLSessionDataTask *task, id responseObject) {
			NSDictionary *createdIssueJSON = responseObject[@"issue"];
			RACSignal *mapping = [GRTJSONSerialization rac_mergeObjectForEntityName:@"Issue" fromJSONDictionary:createdIssueJSON inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]]; //TODO: which context to map to and where to save changes?
			[mapping subscribe:subscriber];
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			   NSHTTPURLResponse *response = (id)task.response;

			[subscriber sendError:error];

		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

-(RACSignal *)updateIssue:(EditedIssue *)issue
{
	return [[[[self serializeIssue:issue] flattenMap:^RACStream *(id value) {
		return [[self updateIssueWithId:issue.identifier JSON:value] then:^RACSignal *{
			return [self _fetchDetailOfIssueWithId:issue.identifier]; //we dont get new issue to map from server, but to be consistent with createIssue:, we return the original issue here
		}];
	}]deliverOn:[RACScheduler currentScheduler]]
			  replayLazily];
}


-(RACSignal *)updateIssueWithId:(NSNumber *)issueId JSON:(NSDictionary *)issueJSON
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSURLSessionDataTask *task = [self.sessionManager PUT:[NSString stringWithFormat:@"/issues/%@.json",issueId]  parameters:issueJSON success:^(NSURLSessionDataTask *task, id responseObject) {
			;
            
            if (issueJSON[@"issue"][@"category_id"] == nil || issueJSON[@"issue"][@"category_id"] == [NSNull null]) {
                Issue *issue = [Issue MR_findFirstByAttribute:@"identifier" withValue:issueJSON[@"issue"][@"id"]];
                
                issue.category = nil;
                
                [issue.managedObjectContext MR_saveToPersistentStoreAndWait];
            }
            
			[subscriber sendCompleted];
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			NSHTTPURLResponse *response = (id)task.response;
			
			[subscriber sendError:error];
			
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}


-(RACSignal *)deleteIssue:(Issue *)issue
{
    return  [[self _deleteIssue:issue] replayLazily];
}


-(RACSignal *)_deleteIssue:(Issue *)issue
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self.sessionManager DELETE:[NSString stringWithFormat:@"/issues/%@.json",issue.identifier]  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            ;
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSHTTPURLResponse *response = (id)task.response;
            
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


#pragma mark state restoration

NSString *const SavedIssueFileName = @"SavedIssue";

-(void)saveIssueForLater:(EditedIssue *)issue
{
	NSString *filePath = [[NSFileManager defaultManager] pathForPublicFile:SavedIssueFileName];
	[NSKeyedArchiver archiveRootObject:issue toFile:filePath];
}

-(EditedIssue *)getSavedIssue
{
	NSString *filePath = [[NSFileManager defaultManager] pathForPublicFile:SavedIssueFileName];
   return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

-(void)removeSavedIssue
{
	NSString *filePath = [[NSFileManager defaultManager] pathForPublicFile:SavedIssueFileName];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

-(RACSignal *)addTimeIssue:(Issue *)issue andHours:(NSNumber*)hour andDate:(NSDate*) date andActivity:(TimeEntryActivity*)activity andCommnet:(NSString *)comment
{
    return [[[self serializeAddTime:issue andHours:hour andDate:date andActivity:activity andCommnet:comment] flattenMap:^RACStream *(id value) {
        return [self _addTimeIssue:value];
    }] replayLazily];
}

-(RACSignal *)_addTimeIssue:(NSDictionary *)issueJSON
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self.sessionManager POST:@"/time_entries.json" parameters:issueJSON success:^(NSURLSessionDataTask *task, id responseObject) {
             [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSHTTPURLResponse *response = (id)task.response;
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

-(RACSignal *)serializeAddTime:(Issue *)issue andHours:(NSNumber*)hour andDate:(NSDate*) date andActivity:(TimeEntryActivity*)activity andCommnet:(NSString *)comment
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if(issue.identifier) dict[@"issue_id"] = issue.identifier;
        if(hour) dict[@"hours"] = hour;
        if(activity.identifier) dict[@"activity_id"] = activity.identifier;
        if (comment) dict[@"comments"] = comment;
        if(date){
            NSString *dateString = [[NSValueTransformer valueTransformerForName:RMDateTransformerName] reverseTransformedValue:date];
            if(dateString) dict[@"spent_on"] = dateString;
        }
        NSDictionary *resultJSON = @{@"time_entry" : dict};
        [subscriber sendNext:resultJSON];
        [subscriber sendCompleted];
        
        return nil;
    }];
}


-(RACSignal *)addComment:(NSString *)comment toIssue:(Issue *)issue
{
	return [[[[self updateIssueWithId:issue.identifier JSON:@{@"issue" :@{@"notes" : comment}}]
				then:^RACSignal *{
					return [self fetchDetailOfIssues:issue];
				}]
				deliverOn:[RACScheduler currentScheduler]] replayLazily];
}

-(RACSignal *)addComment:(NSString *)comment toIssue:(Issue *)issue status:(NSNumber *)status assignee:(NSNumber *)assignee
{
    return [[[[self updateIssueWithId:issue.identifier JSON:@{@"issue" :@{@"notes" : comment, kFilterStatusIdKey: status, kFilterAssignedToIdKey: assignee}}]
              then:^RACSignal *{
                  return [self fetchDetailOfIssues:issue];
              }]
             deliverOn:[RACScheduler currentScheduler]] replayLazily];
}

+(NSString *)backgroundSessionIdentifier
{
	static int SessionId = 0; //dont create same background session twice, TODO: nekodit jako prase
	return [[[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".background-session"] stringByAppendingString:[@(SessionId++) stringValue]];
}
-(AFHTTPSessionManager *)createBackgroundSessionManager
{
	NSString *identifier = [[self class] backgroundSessionIdentifier];
	NSURLSessionConfiguration *c = [[NSURLSessionConfiguration class] respondsToSelector:@selector(backgroundSessionConfigurationWithIdentifier:)] ? [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier] : [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
	AFHTTPSessionManager *m = [[AFHTTPSessionManager alloc] initWithBaseURL:self.sessionManager.baseURL sessionConfiguration:c];
	for(id key in [self.sessionManager.requestSerializer.HTTPRequestHeaders allKeys]) {
		[m.requestSerializer setValue:self.sessionManager.requestSerializer.HTTPRequestHeaders[key] forHTTPHeaderField:key];
}

	[m setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
		[self URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
	}];

	[m setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
		[self URLSession:session task:task didCompleteWithError:error];
	}];
	
	[m setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
		[self URLSession:session dataTask:dataTask didReceiveData:data];
	}];
	
	return m;
}


-(RACSignal *)getUploadTasks
{
	return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.backgroundSessionManager.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
			[subscriber sendNext:uploadTasks];
			[subscriber sendCompleted];
		}];
		return nil;
	}] deliverOn:[RACScheduler currentScheduler]] replayLazily];
}

-(RACSignal *)uploadAttachment:(FileUpload *)attachment
{
	return [[[[[[self getUploadTasks] flattenMap:^RACStream *(NSArray *tasks) {
		NSURLSessionUploadTask *task = [[[tasks.rac_sequence filter:^BOOL(id value) {
			return [value taskIdentifier] == [attachment.uploadTaskIdentifier unsignedIntegerValue];
		}] array] firstObject];
		 if(task) {
			 return [RACSignal return:task];
		 }
		 else {
			 return [[RACSignal defer:^RACSignal *{
				 NSError *error;
				NSURLRequest *request = [self.backgroundSessionManager.requestSerializer requestWithMethod:@"POST" URLString:[self.backgroundSessionManager.baseURL.absoluteString stringByAppendingString:@"/uploads.json"] parameters:nil error:&error];
				 if(error){
					 return [RACSignal return:error];
				 }
				 NSURLSessionUploadTask *task = [self.backgroundSessionManager uploadTaskWithRequest:request fromFile:attachment.localUrl progress:nil completionHandler:nil];
				 [task resume];
				 return [RACSignal return:task];
			 }] doNext:^(NSURLSessionUploadTask *task) {
				 attachment.uploadTaskIdentifier = @(task.taskIdentifier);
				 self.uploadDictionary[@([task taskIdentifier]).description /*use string keys to allow KVC*/] = [self progressAndCompletedSignalForTask:task];
			 }];
		 }
	 }] take:1]
		map:^id(NSURLSessionUploadTask *task) {
		NSString *key = [@([task taskIdentifier]) description];
			return self.uploadDictionary[key];
	 }] deliverOn:[RACScheduler mainThreadScheduler]] replayLazily];
}



//TODO dont implement these methods and usse rac_signalForSelector:fromProtocol: insted
//these methods must be implemented so they can be used by rac_signalForSelector:
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	
	
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
}

-(RACSignal *)validateIssue:(EditedIssue *)issue
{
	switch (self.apiType) {
	case RMApiTypeEasyRM:
			return [self easy_validateIssue:issue];
  case RMApiTypeOriginal:   default:
			return [self rm_validateIssue:issue];
	}
}

-(RACSignal *)rm_validateIssue:(EditedIssue *)issue
{
	RACSignal *validationSignal = [RACSignal empty];
	if(!issue.project[@"value"]){
		validationSignal = [[self fetchAvailableProjectsForIssue:issue] doNext:^(NSArray *x) {
			issue.availableProjects = [x.rac_sequence map:^id(Project *value) {
				return @{@"value" : value.identifier, @"name" : value.name};
			}].array;
		}];
	}
	else{
		if(!issue.availableProjects){
			validationSignal = [[self fetchAvailableProjectsForIssue:issue] doNext:^(NSArray *x) {
				issue.availableProjects = [x.rac_sequence map:^id(Project *value) {
					return @{@"value" : value.identifier, @"name" : value.name};
				}].array;
			}];
		}
		RACSignal *membersSignal = [[self fetchMembersOfProjectWithId:issue.project[@"value"]] doNext:^(id x) {
			issue.availableAssignees = x;
		}];
		RACSignal *trackersAndCategoriesSignal = [[self fetchTrackersAndCategoriesForProjectWithId:issue.project[@"value"]] doNext:^(RACTuple *x) {
			issue.availableTrackers = x.first;
			issue.availableCategories = x.second;
		}];
		RACSignal *statusesSignal = [[self fetchIssueStatuses] doNext:^(id x) {
			issue.availableStatuses = x;
		}];
        RACSignal *fixedVersionsSignal = [[self fetchIssueFixedVersionsWithProjectId:issue.project[@"value"]] doNext:^(id x) {
            issue.availableFixedVersions = x;
        }];
		RACSignal *prioritiesSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			issue.availablePriorities = [[Priority MR_findAllSortedBy:@"identifier" ascending:YES].rac_sequence map:^id(Priority *value) {
				return @{@"value" : value.identifier, @"name" : value.name};
			}].array;
			[subscriber sendNext:issue.availablePriorities];
			[subscriber sendCompleted];
			return nil;
		}];
		
		validationSignal = [validationSignal then:^RACSignal *{
			return [RACSignal combineLatest:@[membersSignal, fixedVersionsSignal, trackersAndCategoriesSignal, statusesSignal, prioritiesSignal]];
		}];
	}
	return [validationSignal then:^RACSignal *{
		return [RACSignal return:issue];
	}];
}

-(RACSignal *)fetchAvailableProjectsForIssue:(EditedIssue *)issue
{
	//fetch all projects
	NSArray *results = [Project MR_findAll];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	results = [results sortedArrayUsingDescriptors:@[descriptor]];
	return [RACSignal return:results];
}

-(RACSignal *)easy_validateIssue:(EditedIssue *)issue
{
	NSString *path;
	if(issue.identifier){ //edit
		path = [NSString stringWithFormat:@"/easy_issues/fields/%@.json", issue.identifier];
	}else{ //new
		if(!issue.project[@"value"] || issue.project[@"value"] == NSNull.null) { //just fetch projects from db
			NSArray *projects = [Project MR_findAll];
			projects = [projects.rac_sequence map:^id(id value) {
				return @{@"value" : [value identifier], @"name" : [value name]};
			}].array;
			return [[[RACSignal return:issue] doNext:^(id x) {
				issue.availableProjects = projects;
			}] replayLazily];
		}
		path = [NSString stringWithFormat:@"/easy_issues/%@/fields.json", issue.project[@"value"]];
	}

	return [[[self serializeIssue:issue] flattenMap:^RACStream *(id value) {
				return [self _validateIssue:value path:path];
	}] replayLazily];
}

-(RACSignal *)_validateIssue:(NSDictionary *)issueJSON path:(NSString *)path
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSURLSessionDataTask *task = [self.sessionManager POST:path parameters:issueJSON success:^(NSURLSessionDataTask *task, id responseObject) {
//				TRC_OBJ(responseObject);
				TRC_ENTRY;
				NSDictionary *formAttr = responseObject[@"form_attributes"];
				NSDictionary *issueJSON = formAttr[@"issue"];
				
				//OMG, create temporary context, map Issue using groot, then create EditedIssue from Issue
				NSError *coreDataError;
				NSManagedObjectContext *tempContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
				Issue *tempIssue = [GRTJSONSerialization insertObjectForEntityName:@"Issue" fromJSONDictionary:issueJSON inManagedObjectContext:tempContext error:&coreDataError];
				if(coreDataError){
					[subscriber sendError:coreDataError];
				}else{
					EditedIssue *validatedIssue = [[EditedIssue alloc] initWithIssue:tempIssue];
					tempContext = nil;
					
					validatedIssue.availableProjects = formAttr[@"available_projects"];
					validatedIssue.availableAssignees = formAttr[@"available_assignees"];
					validatedIssue.availableTrackers = formAttr[@"available_trackers"];
					validatedIssue.availablePriorities = formAttr[@"available_priorities"];
					validatedIssue.availableStatuses = formAttr[@"available_statuses"];
					validatedIssue.availableActivities = formAttr[@"available_activities"];
					validatedIssue.availableCategories = formAttr[@"available_categories"];
					validatedIssue.availableFixedVersions = formAttr[@"available_fixed_versions"];
					validatedIssue.availableCustomFields = formAttr[@"available_custom_fields_values"];
															 [subscriber sendNext:validatedIssue];
															 [subscriber sendCompleted];
				}
				
			} failure:^(NSURLSessionDataTask *task, NSError *error) {
				[subscriber sendError:error];
			}];
			return [RACDisposable disposableWithBlock:^{
				[task cancel];
			}];
		}];
}


-(NSURLRequest *)requestWithMethod:(NSString *)method url:(NSURL *)url
{
	return [self.sessionManager.requestSerializer requestWithMethod:method URLString:url.absoluteString parameters:nil error:nil];
}

-(RACSignal *)fetchMembersOfProjectWithId:(NSNumber *)projectId
{
	return [[self _fetchMembersOfProjectWithId:projectId] replayLazily];
}

-(RACSignal *)_fetchMembersOfProjectWithId:(NSNumber *)projectId
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSString *path = [NSString stringWithFormat:@"/projects/%@/memberships.json", projectId];
		NSURLSessionDataTask *task = [self.sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
			NSArray *memberships = responseObject[@"memberships"];
			NSArray *users = [[memberships.rac_sequence filter:^BOOL(id value) {
				return value[@"user"] != nil;
			}] map:^id(id value) {
				return @{@"value" : value[@"user"][@"id"], @"name" : value[@"user"][@"name"]};
			}].array;
			NSArray *groups = [[memberships.rac_sequence filter:^BOOL(id value) {
				return value[@"group"] != nil;
			}] map:^id(id value) {
				return @{@"value" : value[@"group"][@"id"], @"name" : value[@"group"][@"name"]};
			}].array;
			NSMutableArray *res = [NSMutableArray array];
			if(users.count > 0){
				[res addObject:@{@"name" : @"Users:", @"values" : users}];
			}
			if(groups.count > 0){
				[res addObject:@{@"name":@"Groups:", @"values" : groups}];
			}
			[subscriber sendNext:res];
			[subscriber sendCompleted];
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			[subscriber sendError:error];
		}];
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

-(RACSignal *)fetchTrackersAndCategoriesForProjectWithId:(NSNumber *)projectId //sends ractuple, first is array of trackers, second array of issue_categories
{
	return [[self _fetchTrackersAndCategoriesForProjectWithId:projectId] replayLazily];
}

-(RACSignal *)fetchIssueFixedVersionsWithProjectId:(NSNumber *)projectId
{
    return [[self _fetchIssueFixedVersionsWithProjectId:projectId] replayLazily];
}

-(RACSignal *)_fetchIssueFixedVersionsWithProjectId:(NSNumber *)projectId
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *path = [NSString stringWithFormat:@"projects/%@/versions.json", projectId];
        NSURLSessionDataTask *task = [self.sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *versionsJSON = responseObject[@"versions"];
            NSArray *versions = [versionsJSON.rac_sequence map:^id(NSDictionary *value) {
                NSMutableDictionary *status = [value mutableCopy];
                status[@"value"] = status[@"id"];
                [status removeObjectForKey:@"id"];
                return [status copy];
            }].array;
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
            versions = [versions sortedArrayUsingDescriptors:@[descriptor]];
            
            [subscriber sendNext:versions];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

-(RACSignal *)_fetchTrackersAndCategoriesForProjectWithId:(NSNumber *)projectId
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSString *path = [NSString stringWithFormat:@"/projects/%@.json", projectId];
		NSDictionary *params = @{@"include" : @[@"trackers", @"issue_categories"]};
		NSURLSessionDataTask *task = [self.sessionManager GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
			NSDictionary *projectJSON = responseObject[@"project"];
			NSManagedObjectContext *tempContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
			NSError *error;
			Project *project = [GRTJSONSerialization mergeObjectForEntityName:@"Project" fromJSONDictionary:projectJSON inManagedObjectContext:tempContext error:&error];
			if(error){
				[subscriber sendError:error];
			}else{
				NSArray *trackers = [project.trackers.rac_sequence map:^id(Tracker *value) {
					return @{@"value" : [value identifier], @"name" : [value name]};
				}].array;
				NSArray *categories = [project.issueCategories.rac_sequence map:^id(IssueCategory *value) {
					return @{@"value" : [value identifier], @"name" : [value name]};
				}].array;
				tempContext = nil;
                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
                
                trackers = [trackers sortedArrayUsingDescriptors:@[descriptor]];
                categories = [categories sortedArrayUsingDescriptors:@[descriptor]];
				[subscriber sendNext:RACTuplePack(trackers, categories)];
				[subscriber sendCompleted];
			}
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			[subscriber sendError:error];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

-(RACSignal *)fetchIssueStatuses
{
	return [[self _fetchIssueStatuses] replayLazily];
}

-(RACSignal *)_fetchIssueStatuses
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLSessionDataTask *task = [self.sessionManager GET:@"/issue_statuses.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
			NSArray *statusesJSON = responseObject[@"issue_statuses"];
			NSArray *statuses = [statusesJSON.rac_sequence map:^id(NSDictionary *value) {
				NSMutableDictionary *status = [value mutableCopy];
				status[@"value"] = status[@"id"];
				[status removeObjectForKey:@"id"];
				return [status copy];
			}].array;
			
            NSSortDescriptor *description = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
            statuses = [statuses sortedArrayUsingDescriptors:@[description]];
            
			[subscriber sendNext:statuses];
			[subscriber sendCompleted];
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			[subscriber sendError:error];
		}];
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}


-(void)sendEmail:(NSString *)email andPhone:(NSString *)phone
{
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://es.easyproject.cz/projects/1719/easy_crm_cases.json?key=50d441e2eef45f7f138d8e91afb1e298e07f9f70"]];
	req.HTTPMethod = @"POST";
	NSMutableDictionary *parameters = [@{@"name" : @"Mobile App contact" } mutableCopy];
	if(email) {
		parameters[@"email"] = email;
	}
	if(phone) {
		parameters[@"telephone"] = phone;
	}
	
	NSURLRequest *reqWithParams = [self.sessionManager.requestSerializer requestBySerializingRequest:req withParameters:@{@"easy_crm_case" :parameters } error:nil];
	
	NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:reqWithParams completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		if(error) {
			TRC_OBJ(error);
		}
	}];
	[task resume];
	
}

-(void)reset
{
	self.sessionManager = nil;
	self.backgroundSessionManager = nil;
}

@end
