//
//  NSRelationshipDescription+Groot.h
//  Estheticon
//
//  Created by Petr Šíma on Mar/27/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSRelationshipDescription (Groot)

@property (nonatomic, readonly) NSPropertyDescription *grt_destinationProperty;

@end
