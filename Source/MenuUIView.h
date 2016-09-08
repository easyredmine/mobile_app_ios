//
//  MenuUIView.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuUIView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *issueUIButton;
@property (nonatomic,strong) UIView *textFiledView;
@property (nonatomic,strong)  UITextField *searchUITextField;
@property (nonatomic,strong) UILabel *emailUILabel;
@property (nonatomic,strong) NSArray *searchResults;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *createNewIssueButton;
@property (nonatomic,strong) UIButton *logoutUIButton;
@property (nonatomic,strong) UIView *delimiterUpView;
@property (nonatomic,strong) UIView *delimiteDownView;
@end
