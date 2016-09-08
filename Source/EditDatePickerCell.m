//
//  EditDatePickerCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/5/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditDatePickerCell.h"

@interface EditDatePickerCell ()  {
}

@end

@implementation EditDatePickerCell

-(void)setup
{
	UIDatePicker *p = [UIDatePicker new];
	p.datePickerMode = UIDatePickerModeDate;
	[self.contentView addSubview:p];
	[p mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];
	self.picker = p;
	
	[p addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]){
		[self setup];
	}
	return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ]){
		[self setup];
	}
	return self;
}

-(void)setSelectedDate:(NSDate *)selectedDate
{
	_selectedDate = selectedDate;
	if(selectedDate){
		[self.picker setDate:selectedDate animated:NO];
	}
}

-(void)dateChanged:(UIDatePicker *)sender
{
	NSDate *newDate = sender.date;
	self.selectedDate = newDate;
}

@end
