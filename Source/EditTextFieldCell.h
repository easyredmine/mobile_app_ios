//
//  EditTextFieldCell.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/5/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTextFieldCell : UITableViewCell

@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UITextField *textField;

@end
