//
//  EditPushCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditPlainCell.h"

@implementation EditPlainCell

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
	ll.adjustsFontSizeToFitWidth = YES;
	ll.minimumScaleFactor = 0.5;
	[ll setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[self.contentView addSubview:ll];
	[ll mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.top.and.bottom.equalTo(self.contentView).with.insets(kContentInsets);
	}];
	self.leftLabel = ll;

	UILabel *rl = [UILabel new];
	rl.textColor = [UIColor darkTextColor];
	[rl setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[self.contentView addSubview:rl];
	[rl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.and.bottom.equalTo(self.contentView).with.insets(kContentInsets);
		make.right.equalTo(self.contentView).with.insets(kContentInsets);
		make.left.greaterThanOrEqualTo(ll.mas_right).with.offset(8);
		make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.5); //leave some space for description label
	}];
	self.rightLabel = rl;
	
	UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	ind.hidden = YES;
	[self.contentView addSubview:ind];
	[ind mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.and.right.equalTo(rl);
	}];
	self.activityIndicator = ind;
	
}

-(void)prepareForReuse
{
	[super prepareForReuse];
	self.accessoryType = UITableViewCellAccessoryNone;
	self.rightLabel.textColor = [UIColor darkTextColor];
	self.rightLabel.hidden = NO;
	self.activityIndicator.hidden = YES;
	self.leftLabel.textColor = [UIColor darkTextColor];
	self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
	[super setAccessoryType:accessoryType];
	if(accessoryType == UITableViewCellAccessoryNone){
		[self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).with.insets(kContentInsets);
		}];
	}else{
		[self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).with.insets(kContentInsetsWithDisclosureIndicator);
		}];
	}
	[self setNeedsLayout];
}

@end
