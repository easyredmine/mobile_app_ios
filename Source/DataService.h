//
//  DataService.h
//  RACTest
//
//  Created by Petr Šíma on Mar/9/15.
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "EditedIssue.h"

extern NSString * const RMDateTransformerName;

#pragma mark Request Filters
//define dictionary keys for request parameters
extern NSString *const kFilterOffsetKey; //default is 0
extern NSString *const kFilterLimitKey; //default is INT_MAX
extern NSString *const kFilterProjectIdKey;
extern NSString *const kFilterAssignedToIdKey;
extern NSString *const kFilterQueryIdKey;

extern NSString *const kFilterSetFiltertKey;
extern NSString *const kFilterStatusIdKey;
extern NSString *const kFilterWatchIdKey;
extern NSString *const kFilterLastUpdateOnKey;
extern NSString *const kFilterFavoriteKey;
extern NSString *const kFilterAuthorIdKey;
#pragma mark -

#pragma mark uploadDictionary
extern NSString *const ProgressKey;
extern NSString *const TokenKey;
extern NSString *const TotalBytesSentKey;
extern NSString *const TotalBytesExpectedKey;
#pragma mark -

typedef NS_ENUM(NSUInteger, RMApiType) {
	RMApiTypeOriginal,
	RMApiTypeEasyRM
};

@interface DataService : NSObject
+(instancetype)sharedService;

//data service initializes its state based on the parameters given here. The credentials are only stored in DB if the request succeeds
-(RACSignal *)loginAndDownloadProjectsWithUserCredentials:(UserCredentials *)cred apiType:(RMApiType)type;
-(RACSignal *)fetchQueries;
-(RACSignal *)fetchIssuesWithFilter:(NSDictionary *)filter;
-(RACSignal *)fetchDetailOfIssues:(Issue *)issue;
-(RACSignal *)fetchEnumerations;

-(RACSignal *)createIssue:(EditedIssue *)issue;
-(RACSignal *)updateIssue:(EditedIssue *)issue;
-(RACSignal *)deleteIssue:(Issue *)issue;


-(RACSignal *)addTimeIssue:(Issue *)issue andHours:(NSNumber*)hour andDate:(NSDate*) date andActivity:(TimeEntryActivity*)activity andCommnet:(NSString *)comment;

-(RACSignal *)addComment:(NSString *)comment toIssue:(Issue *)issue;
-(RACSignal *)addComment:(NSString *)comment toIssue:(Issue *)issue status:(NSNumber *)status assignee:(NSNumber *)assignee;


-(void)saveIssueForLater:(EditedIssue *)issue;
-(EditedIssue *)getSavedIssue;
-(void)removeSavedIssue;

-(RACSignal *)uploadAttachment:(FileUpload *)attachment;

-(RACSignal *)validateIssue:(EditedIssue *)issue;


//-(RACSignal *)downloadFileAtUrl:(NSURL *)url;
-(NSURLRequest *)requestWithMethod:(NSString *)method url:(NSURL *)url;


@property (nonatomic, readonly) NSMutableDictionary *uploadDictionary; //dictionary of hot signals providing information about currently running uploads.

-(void)reset; //deletes both session managers just to be safe

-(void)sendEmail:(NSString *)email andPhone:(NSString *)phone; //just try to make a request and dont care about the result, no need to use RACSignal
@end
