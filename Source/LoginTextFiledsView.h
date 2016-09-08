//
//  LoginTextFiledsView.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUITextField.h"


@interface LoginTextFiledsView : UIView

@property (strong,nonatomic) UIImageView *logoImageView;
@property (strong,nonatomic) UILabel *domainTextLabel;
@property (strong,nonatomic) LoginUITextField *domainTextField;
@property (strong,nonatomic) UILabel *usernameTextLabel;
@property (strong,nonatomic) LoginUITextField *usernameTextField;
@property (strong,nonatomic) UILabel *passwordTextLabel;
@property (strong,nonatomic) LoginUITextField *passwordTextField;
@property (strong,nonatomic) UILabel *emailTextLabel;
@property (strong,nonatomic) LoginUITextField *emailTextField;
@property (strong,nonatomic) UILabel *phoneTextLabel;
@property (strong,nonatomic) LoginUITextField *phoneTextField;
@property (strong,nonatomic) UIButton *signUIButton;
@property (strong,nonatomic) UIButton *switchRedminesUIButton;

@property (nonatomic, assign) BOOL showsEmailAndPhone;
@end
