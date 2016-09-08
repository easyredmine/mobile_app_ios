//
//  NSNumber+SelectionItem.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/3/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "NSNumber+PercentSelectionItem.h"

@implementation NSNumber (PercentSelectionItem)

-(NSString *)name
{
	return [NSString stringWithFormat:@"%lu%%", self.unsignedIntegerValue];
}

@end
