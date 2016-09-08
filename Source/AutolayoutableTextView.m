//
//  AutolayoutableTextView.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/11/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "AutolayoutableTextView.h"

@implementation AutolayoutableTextView

-(CGSize)intrinsicContentSize
{
	CGSize intrinsicSize = [super intrinsicContentSize];
	CGSize contentSize = self.contentSize;
	CGSize resultSize = CGSizeMake(intrinsicSize.width, MAX(self.font.pointSize + self.textContainerInset.top + self.textContainerInset.bottom + 4 /*wtf why +4?*/, contentSize.height));
	TRC_LOG(@"%@",NSStringFromCGSize(resultSize));
	return resultSize;
}



-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
	[UIView performWithoutAnimation:^{
		[super setContentOffset:contentOffset];
	}];
}


@end
