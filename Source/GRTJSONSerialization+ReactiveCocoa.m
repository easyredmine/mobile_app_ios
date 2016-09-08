//
//  GRTJSONSerialization+ReactiveCocoa.m
//  EasyRedmine
//
//  Created by Petr Šíma on Mar/20/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "GRTJSONSerialization+ReactiveCocoa.h"

@implementation GRTJSONSerialization (ReactiveCocoa)

+(RACSignal *)rac_mergeObjectsForEntityName:(NSString *)entityName fromJSONArray:(NSArray *)JSONArray inManagedObjectContext:(NSManagedObjectContext *)context
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSError *error;
		NSArray *objects = [GRTJSONSerialization mergeObjectsForEntityName:entityName fromJSONArray:JSONArray inManagedObjectContext:context error:&error];
		if(error) {
			[subscriber sendError:error];
		}else{
			[subscriber sendNext:objects];
			[subscriber sendCompleted];
		}
		return nil;
	}];
}


+(RACSignal *)rac_mergeObjectForEntityName:(NSString *)entityName fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSError *error;
		id object = [GRTJSONSerialization mergeObjectForEntityName:entityName fromJSONDictionary:JSONDictionary inManagedObjectContext:context error:&error];
		if(error) {
			[subscriber sendError:error];
		}else{
			[subscriber sendNext:object];
			[subscriber sendCompleted];
		}
		return nil;
	}];
}

@end
