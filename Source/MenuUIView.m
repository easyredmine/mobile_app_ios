//
//  MenuUIView.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "MenuUIView.h"


@implementation MenuUIView
static CGFloat sideSpace = 35.0f;

- (id)init
{
    
    self = [super init];
    if (self) {
        
        UIView *spacerZero = [UIView new];
        spacerZero.backgroundColor = [UIColor clearColor];
        [self addSubview:spacerZero];
        [spacerZero mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.greaterThanOrEqualTo(@2).with.priorityHigh();
            make.height.lessThanOrEqualTo(@40);
        }];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[RedmineUI imageNamed:@"logo_white"]];
        [self addSubview:logoImageView];
        
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(sideSpace);
            make.top.equalTo(spacerZero.mas_bottom).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-sideSpace);
            make.height.mas_equalTo(60);
        }];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.logoImageView = logoImageView;
        
        UIView *spacerOne = [UIView new];
        spacerOne.backgroundColor = [UIColor clearColor];
        [self addSubview:spacerOne];
        [spacerOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(logoImageView.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.greaterThanOrEqualTo(@2).with.priorityHigh();
            make.height.lessThanOrEqualTo(@24);
        }];
        
        
        UILabel *emailUILabel = [UILabel new];
        [self addSubview:emailUILabel];
        [emailUILabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(spacerOne.mas_bottom).with.offset(5);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(20);
        }];
        emailUILabel.textColor = [UIColor whiteColor];
        emailUILabel.textAlignment = NSTextAlignmentCenter;
        self.emailUILabel = emailUILabel;
        
        
        
        UIView *spacerTwo = [UIView new];
        spacerTwo.backgroundColor = [UIColor clearColor];
        [self addSubview:spacerTwo];
        [spacerTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(emailUILabel.mas_bottom).with.offset(10);
            make.right.equalTo(self.mas_right);
            make.height.greaterThanOrEqualTo(@5).with.priorityHigh();
            make.height.lessThanOrEqualTo(@15);
        }];
        
        
        UIView *textFiledView = [UIView new];
        textFiledView.backgroundColor = kColorMainDark;
        [textFiledView setTintColor:[UIColor whiteColor]];
        [self addSubview:textFiledView];
        [textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(spacerTwo.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(44);
        }];
        self.textFiledView = textFiledView;
        
        UIImageView *magnifier = [[UIImageView alloc ]initWithImage:[RedmineUI imageNamed:@"magnifier"]];
        [textFiledView addSubview:magnifier];
        [magnifier mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(textFiledView.mas_left).with.offset(10);
            make.centerY.equalTo(textFiledView);
        }];
        
        UIButton *cancelButton = [[UIButton alloc ]init];
        [textFiledView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(textFiledView.mas_right).with.offset(-10);
            make.centerY.equalTo(textFiledView);
            make.width.equalTo(@40);
        }];
        [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        self.cancelButton = cancelButton;
        
        UITextField *searchUITextField = [UITextField new];
        [textFiledView addSubview:searchUITextField];
        searchUITextField.textColor = [UIColor whiteColor];
        searchUITextField.backgroundColor = [UIColor clearColor];
        [searchUITextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(@0);
            make.left.equalTo(magnifier.mas_left).with.offset(30);
            make.right.equalTo(textFiledView.mas_right).with.offset(-30);
        }];

        self.searchUITextField = searchUITextField;
        
        UIButton *newIssueUIButton = [UIButton new];
        [self addSubview:newIssueUIButton];
        [newIssueUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(textFiledView.mas_bottom).with.offset(10);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(54);
        }];
        [newIssueUIButton setTitleColor:kGrayColor forState:UIControlStateHighlighted];
        newIssueUIButton.backgroundColor = [UIColor clearColor];
        [newIssueUIButton setTitle:NSLocalizedString(@"menu_new_issues", @"") forState:UIControlStateNormal];
        newIssueUIButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        [newIssueUIButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [newIssueUIButton setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 40.0f, 0.0f, 0.0f)];
        
        
        self.createNewIssueButton = newIssueUIButton;
        
        UIView *delimiterUpView = [UIView new];
        [self addSubview:delimiterUpView ];
        [delimiterUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(newIssueUIButton.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(1);
        }];
        delimiterUpView.backgroundColor = kColorMainDark;
        self.delimiterUpView = delimiterUpView;
        
        UIButton *issuesUIButton = [UIButton new];
        [self addSubview:issuesUIButton];
        [issuesUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(delimiterUpView.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(47);
        }];
        [issuesUIButton setTitleColor:kGrayColor forState:UIControlStateHighlighted];
        issuesUIButton.backgroundColor = [UIColor clearColor];
        [issuesUIButton setTitle:NSLocalizedString(@"menu_issues", @"") forState:UIControlStateNormal];
        issuesUIButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        [issuesUIButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [issuesUIButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 0.0f)];
        self.issueUIButton = issuesUIButton;
        
        
        UIView *delimiterDownView = [UIView new];
        [self addSubview:delimiterDownView ];
        [delimiterDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(issuesUIButton.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(1);
        }];
        delimiterDownView.backgroundColor = kColorMainDark;
        self.delimiteDownView = delimiterDownView;
        
        UIButton *logoutUIButton = [UIButton new];
        [self addSubview:logoutUIButton];
        [logoutUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(delimiterDownView.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(47);
        }];
        
        [logoutUIButton setTitleColor:kGrayColor forState:UIControlStateHighlighted];
        logoutUIButton.backgroundColor = [UIColor clearColor];
        [logoutUIButton setTitle:NSLocalizedString(@"menu_logout", @"") forState:UIControlStateNormal];
        logoutUIButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        [logoutUIButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [logoutUIButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 0.0f)];
        self.logoutUIButton = logoutUIButton;
    
        UIView *spacerThree = [UIView new];
        spacerThree.backgroundColor = [UIColor clearColor];
        [self addSubview:spacerThree];
        [spacerThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(logoutUIButton.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.greaterThanOrEqualTo(@140).with.priorityHigh();
            make.height.lessThanOrEqualTo(@250);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }

    return self;
}

@end
