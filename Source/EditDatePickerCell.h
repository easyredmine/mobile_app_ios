//
//  EditDatePickerCell.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/5/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDatePickerCell : UITableViewCell

@property (nonatomic, weak) UIDatePicker *picker;
@property (nonatomic, strong) NSDate *selectedDate;

@end
