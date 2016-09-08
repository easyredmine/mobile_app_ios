//
//  EditTextFieldCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/5/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditTextFieldCell.h"

@implementation EditTextFieldCell


#define kContentInsets UIEdgeInsetsMake(15,15,15,15)
#define kContentInsetsWithDisclosureIndicator UIEdgeInsetsMake(15,15,15,0)


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
	UILabel *ll = [UILabel new];
	ll.textColor = [UIColor darkTextColor];
	//this label really wants to be exactly its instrinsic size
	[ll setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[ll setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[self.contentView addSubview:ll];
	[ll mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.top.and.bottom.equalTo(self.contentView).with.insets(kContentInsets);
	}];
	self.leftLabel = ll;
	
	UITextField *rtf = [UITextField new];
	rtf.textColor = [UIColor darkTextColor];
	rtf.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:rtf];
	[rtf mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.and.bottom.equalTo(self.contentView); //fill height of cell, so that the keyboard starts below cell
		make.right.equalTo(self.contentView).with.insets(kContentInsets);
		make.left.equalTo(ll.mas_right).with.offset(8);
	}];
	self.textField = rtf;
	rtf.userInteractionEnabled = NO;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)prepareForReuse
{
	[super prepareForReuse];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	self.textField.userInteractionEnabled = selected;
}

@end
