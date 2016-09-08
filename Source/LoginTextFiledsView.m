//
//  LoginTextFiledsView.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "LoginTextFiledsView.h"


@implementation LoginTextFiledsView

static CGFloat textFieldHeight = 46.0f;
static CGFloat textLabelHeight = 15.0f;
static CGFloat space = 12.0f;
static CGFloat sideSpace = 35.0f;




- (id)init
{
    
    self = [super init];
    if (self) {
      
        self.backgroundColor = [UIColor whiteColor];

       
        
        //--LOGO UIView
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[RedmineUI imageNamed:@"logo"]];
        
        [self addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@50);
            make.height.mas_equalTo(55);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
        }];

        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.logoImageView = logoImageView;
        
        //#####--TEXT--FIELDS--#####
        //------SECTION DOMAIN------
        UILabel *domainTextLabel = [self createUILabel];
        
        [self addSubview:domainTextLabel];
        [domainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textLabelHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(logoImageView.mas_bottom).with.offset(50);
        }];
		 domainTextLabel.text = NSLocalizedString(@"login_server_url", @"");
        self.domainTextLabel = domainTextLabel;
        
        LoginUITextField *domainTextField = [LoginUITextField new];
        
        [self addSubview:domainTextField];
        [domainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textFieldHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(domainTextLabel.mas_bottom).with.offset(3);;
        }];
        domainTextField.layer.borderColor=[kGrayColor CGColor];
        [domainTextField setReturnKeyType:UIReturnKeyNext];
        self.domainTextField = domainTextField;
        domainTextField.descriptionLabel = domainTextLabel;
        
        //------SECTION USERNAME------
        UILabel *usernameTextLabel = [self createUILabel];
        
        [self addSubview:usernameTextLabel];
        [usernameTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textLabelHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(domainTextField.mas_bottom).with.offset(space);
        }];
		 usernameTextLabel.text = NSLocalizedString(@"login_username", @"");
        self.usernameTextLabel = usernameTextLabel;
        
        LoginUITextField *usernameTextField = [LoginUITextField new];
        
        [self addSubview:usernameTextField];
        [usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textFieldHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(usernameTextLabel.mas_bottom).with.offset(3);
        }];
        usernameTextField.layer.borderColor=[kGrayColor CGColor];
        [usernameTextField setReturnKeyType:UIReturnKeyNext];
        self.usernameTextField = usernameTextField;
        
        //------SECTION PASSWORD------
        UILabel *passwordTextLabel = [self createUILabel];
        
        [self addSubview:passwordTextLabel];
        [passwordTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textLabelHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(usernameTextField.mas_bottom).with.offset(space);
        }];
		 passwordTextLabel.text = NSLocalizedString(@"login_password", @"");
        self.passwordTextLabel = passwordTextLabel;
        
        LoginUITextField *passwordTextField = [LoginUITextField new];
        
        [self addSubview:passwordTextField];
        [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textFieldHeight);
            make.left.mas_equalTo(sideSpace);
            make.right.mas_equalTo(-sideSpace);
            make.top.equalTo(passwordTextLabel.mas_bottom).with.offset(3);;
        }];
        passwordTextField.layer.borderColor=[kGrayColor CGColor];
        passwordTextField.secureTextEntry = YES;
        [passwordTextField setReturnKeyType:UIReturnKeyNext];
        self.passwordTextField = passwordTextField;
		 
//		 ------SECTION email------
		 UILabel *emailTextLabel = [self createUILabel];
		 
		 [self addSubview:emailTextLabel];
		 [emailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			 make.height.mas_equalTo(textLabelHeight);
			 make.left.mas_equalTo(sideSpace);
			 make.right.mas_equalTo(-sideSpace);
			 make.top.equalTo(passwordTextField.mas_bottom).with.offset(space);
		 }];
		 emailTextLabel.text = NSLocalizedString(@"login_email", @"");
		 self.emailTextLabel = emailTextLabel;
		 
		 LoginUITextField *emailTextField = [LoginUITextField new];
		 
		 [self addSubview:emailTextField];
		 [emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
			 make.height.mas_equalTo(textFieldHeight);
			 make.left.mas_equalTo(sideSpace);
			 make.right.mas_equalTo(-sideSpace);
			 make.top.equalTo(emailTextLabel.mas_bottom).with.offset(3);
		 }];
		 emailTextField.layer.borderColor=[kGrayColor CGColor];
		 [emailTextField setReturnKeyType:UIReturnKeyNext];
//		 emailTextField.placeholder = NSLocalizedString(@"login_email_placeholder", @"");
		 self.emailTextField = emailTextField;

//		 ------SECTION phone------
		 UILabel *phoneTextLabel = [self createUILabel];
		 
		 [self addSubview:phoneTextLabel];
		 [phoneTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			 make.height.mas_equalTo(textLabelHeight);
			 make.left.mas_equalTo(sideSpace);
			 make.right.mas_equalTo(-sideSpace);
			 make.top.equalTo(emailTextField.mas_bottom).with.offset(space);
		 }];
		 phoneTextLabel.text = NSLocalizedString(@"login_phone", @"");
		 self.phoneTextLabel = phoneTextLabel;
		 
		 LoginUITextField *phoneTextField = [LoginUITextField new];
		 
		 [self addSubview:phoneTextField];
		 [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
			 make.height.mas_equalTo(textFieldHeight);
			 make.left.mas_equalTo(sideSpace);
			 make.right.mas_equalTo(-sideSpace);
			 make.top.equalTo(phoneTextLabel.mas_bottom).with.offset(3);;
		 }];
		 phoneTextField.layer.borderColor=[kGrayColor CGColor];
		 [phoneTextField setReturnKeyType:UIReturnKeyGo];
//		 phoneTextField.placeholder = NSLocalizedString(@"login_phone_placeholder", @"");
		 self.phoneTextField = phoneTextField;

		 
        //SIGN BUTTON
        UIButton *signUIButton = [UIButton new];
		 
        [self addSubview:signUIButton];
        [signUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneTextField.mas_bottom).with.offset(27);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(@142);
            make.height.mas_equalTo(44);
            
        }];
        [signUIButton setTitleColor:kGrayColor forState:UIControlStateHighlighted];
        signUIButton.backgroundColor = kColorMain;
		 [signUIButton setTitle:NSLocalizedString(@"login_button_login", @"")
 forState:UIControlStateNormal];
        signUIButton.layer.cornerRadius = 22;
        self.signUIButton = signUIButton;

        
        //Button for switch redmines
        UIButton *switchRedminesUIButton = [UIButton new];
        
        [self addSubview:switchRedminesUIButton];
        [switchRedminesUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(signUIButton.mas_bottom).with.offset(35);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(24);
            make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        }];
        [switchRedminesUIButton setTitleColor:kGrayColor forState:UIControlStateHighlighted];
        //Setting up right label for button by actual brand
        if ([[[Brand sharedVisual] getCurrentBrand] isEqual:kEasyRedmine]) {
           [switchRedminesUIButton setTitleColor:kRedmineColor forState:UIControlStateNormal];
			  [switchRedminesUIButton setTitle:NSLocalizedString(@"switch_to_redmine", @"")
 forState:UIControlStateNormal];
        }else{
            [switchRedminesUIButton setTitleColor:kEasyRedmineColor forState:UIControlStateNormal];
			  [switchRedminesUIButton setTitle:NSLocalizedString(@"switch_to_easy_redmine", @"")
 forState:UIControlStateNormal];
        }
        self.switchRedminesUIButton = switchRedminesUIButton;

    }
    return self;
}

#pragma mark helper
-(UILabel*)createUILabel
{
    UILabel *label = [UILabel new];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    label.textColor = kGrayColor;
    return label;
}

-(void)setShowsEmailAndPhone:(BOOL)showsEmailAndPhone
{
	_showsEmailAndPhone = showsEmailAndPhone;
	self.emailTextLabel.hidden = !showsEmailAndPhone;
		self.emailTextField.hidden = !showsEmailAndPhone;
		self.phoneTextLabel.hidden = !showsEmailAndPhone;
		self.phoneTextField.hidden = !showsEmailAndPhone;
	
	if(showsEmailAndPhone){
		[self.emailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			 make.height.mas_equalTo(textLabelHeight);
			 make.left.mas_equalTo(sideSpace);
			 make.right.mas_equalTo(-sideSpace);
			 make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(space);
		}];
	}else{
		[self.emailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {	}];
	}
	
	
	UIView *lastView = showsEmailAndPhone ? self.phoneTextField : self.passwordTextField;
	[self.signUIButton mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(lastView.mas_bottom).with.offset(27);
		make.centerX.equalTo(self);
		make.width.mas_equalTo(@142);
		make.height.mas_equalTo(44);
	}];
	[self setNeedsLayout];
}
@end
