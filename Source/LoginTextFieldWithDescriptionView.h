//
//  LoginTextFieldWithDescriptionView.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 13/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUITextField.h"
@interface LoginTextFieldWithDescriptionView : UIView

@property (strong,nonatomic) UILabel *textLabel;
@property (strong,nonatomic) LoginUITextField *textField;

- (id)initWithDescription:(NSString*)description;
@end
