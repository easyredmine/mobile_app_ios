//
//  LoginTextFieldWithDescriptionView.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 13/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "LoginTextFieldWithDescriptionView.h"

@implementation LoginTextFieldWithDescriptionView
static CGFloat textFieldHeight = 40.0f;
static CGFloat textLabelHeight = 11.0f;

- (id)initWithDescription:(NSString*)description {
    
    self = [super init];
    if (self) {
        
        UILabel *textLabel = [self createUILabel];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textLabelHeight);
            make.left.right.top.equalTo(self);
        }];
        textLabel.text = description;
        textLabel.textColor = kGrayColor;
        self.textLabel = textLabel;
        
        
        LoginUITextField *textField = [LoginUITextField new];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textFieldHeight);
            make.left.right.equalTo(self);
            make.top.equalTo(textLabel.mas_bottom).with.equalTo(@5);
        }];
        textField.layer.borderColor=[kGrayColor CGColor];
        [textField setReturnKeyType:UIReturnKeyNext];
        self.textField = textField;
    }
    return self;
}

-(UILabel*)createUILabel {
    
    UILabel *label = [UILabel new];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    label.textColor = kGrayColor;
    return label;
}
-(void)selectField {
    self.textField.layer.borderColor=[kColorMain CGColor];
    self.textLabel.textColor = kColorMain;
}

-(void)deSelectField {
     self.textField.layer.borderColor=[kGrayColor CGColor];
     self.textLabel.textColor = kGrayColor;
}
@end
