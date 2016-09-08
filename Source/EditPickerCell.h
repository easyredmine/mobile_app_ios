//
//  EditPickerCell.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/2/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditPickerCell : UITableViewCell

@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *selectedItem;

@property (nonatomic, copy) NSString *suffix;

@end
