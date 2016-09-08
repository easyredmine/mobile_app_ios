//
//  NSString+IOS7_containsString.m
//  EasyRedmine
//
//  Created by Petr Šíma on Jun/10/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "NSString+IOS7_containsString.h"

@implementation NSString (IOS7_containsString)


-	(BOOL)containsString:(NSString*)other {
	NSRange range = [self rangeOfString:other];
	return range.length != 0;
}

@end
