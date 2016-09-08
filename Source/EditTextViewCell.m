//
//  EditTextViewCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditTextViewCell.h"

@implementation EditTextViewCell

#define kContentInsets UIEdgeInsetsMake(15,10,15,10)

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		[self setup];
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]){
		[self setup];
	}
	return self;
}

-(void)setup
{
	SZTextView *tv = [SZTextView new];
	tv.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	tv.textColor = [UIColor darkTextColor];
	tv.scrollEnabled = NO; //setting this to NO allows tv to calculate intrinsicContentSize
	[self.contentView addSubview:tv];
	[tv mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.insets(kContentInsets);
	}];
	self.textView = tv;
	tv.userInteractionEnabled = NO;
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
