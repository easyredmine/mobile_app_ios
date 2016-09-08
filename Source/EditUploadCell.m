
//
//  EditUploadCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/20/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditUploadCell.h"
#define kContentInsets UIEdgeInsetsMake(15,15,15,15)

@implementation EditUploadCell

-(void)prepareForReuse
{
	[super prepareForReuse];
	self.progressView.hidden = NO;
	self.label.hidden = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		[self commonInit];
	}
	return self;
}

-(void)commonInit
{
	UIProgressView *progressView = [UIProgressView new];
	[self.contentView addSubview:progressView];
	[progressView mas_makeConstraints:^(MASConstraintMaker *make) {
	make.left.and.right.equalTo(self.contentView).with.insets(kContentInsets);
		make.centerY.equalTo(self.contentView);
	}];
	self.progressView = progressView;
	
	UILabel *label = [UILabel new];
	label.text = @" "; //layout height correctly
	[label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[self.contentView addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.insets(kContentInsets);
	}];
	self.label = label;
}

@end
