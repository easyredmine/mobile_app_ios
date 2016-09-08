//
//  AutoLabel.m
//  EasyRedmine
//
//  Created by Petr Šíma on Jun/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "AutoLabel.h"

@implementation AutoLabel

-(void)layoutSubviews
{
	self.preferredMaxLayoutWidth = self.bounds.size.width;
	[super layoutSubviews];
}

@end
