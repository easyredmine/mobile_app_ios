//
//  EditPickerCell.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/2/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditPickerCell.h"

@interface EditPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>{
}

@end

@implementation EditPickerCell


-(void)prepareForReuse
{
	[super prepareForReuse];
	self.suffix = @"";
}

-(void)setup
{
	UIPickerView *p = [UIPickerView new];
	p.dataSource = self;
	p.delegate = self;
	[self.contentView addSubview:p];
	[p mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];
	self.picker = p;
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.suffix = @"";
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

-(void)setItems:(NSArray *)items
{
	_items = items;
	[self.picker reloadAllComponents];
}

-(void)setSelectedItem:(NSDictionary *)selectedItem
{
	_selectedItem = selectedItem;
	NSUInteger index = [self.items indexOfObject:selectedItem];
	if(index == NSNotFound){
		if(self.items.count > 0){
			[self.picker selectRow:0 inComponent:0 animated:NO];
		}
	}else{
		[self.picker selectRow:index inComponent:0 animated:NO];
	}
}

-(void)setSuffix:(NSString *)suffix
{
	_suffix = suffix;
	[self.picker reloadAllComponents];
}

#pragma mark picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.items.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	//hack for NSNumber items
	if([self.items[row] isKindOfClass:[NSNumber class]]) return [[self.items[row] stringValue] stringByAppendingString:self.suffix];
	return self.items[row][@"name"];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.selectedItem = self.items[row];
}
@end
