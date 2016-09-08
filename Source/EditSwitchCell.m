//
//  EditSwitchCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Jun/5/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditSwitchCell.h"


#define kContentInsets UIEdgeInsetsMake(15,15,15,15)


@implementation EditSwitchCell

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
	[self.contentView addSubview:ll];
	[ll mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.top.and.bottom.equalTo(self.contentView).with.insets(kContentInsets);
	}];
	self.leftLabel = ll;
	
	UISwitch *rs = [UISwitch new];
	[self.contentView addSubview:rs];
	[rs mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.and.bottom.equalTo(self.contentView).with.insets(kContentInsets);
		make.right.equalTo(self.contentView).with.insets(kContentInsets);
		make.left.greaterThanOrEqualTo(ll.mas_right).with.offset(8);
	}];
	self.rightSwitch = rs;
}


@end
