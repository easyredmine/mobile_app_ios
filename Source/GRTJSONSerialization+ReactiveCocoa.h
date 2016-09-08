//
//  GRTJSONSerialization+ReactiveCocoa.h
//  EasyRedmine
//
//  Created by Petr Šíma on Mar/20/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "GRTJSONSerialization.h"

@interface GRTJSONSerialization (ReactiveCocoa)

+(RACSignal *)rac_mergeObjectForEntityName:(NSString *)entityName fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+(RACSignal *)rac_mergeObjectsForEntityName:(NSString *)entityName fromJSONArray:(NSArray *)JSONArray inManagedObjectContext:(NSManagedObjectContext *)context;


@end
