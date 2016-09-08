//
//  NSRelationshipDescription+Groot.m
//  Estheticon
//
//  Created by Petr Šíma on Mar/27/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "NSRelationshipDescription+Groot.h"

@implementation NSRelationshipDescription (Groot)

NSString *const GRTDestinationPropertyName = @"destinationProperty";

-(NSPropertyDescription *)grt_destinationProperty
{
	NSString *destinationKeyPath = self.userInfo[GRTDestinationPropertyName];
	return self.destinationEntity.propertiesByName[destinationKeyPath];
}

@end
