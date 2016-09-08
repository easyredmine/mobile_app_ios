//
//  IssueDetailUIViewController.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IssueDetailViewController;

@protocol IssueDetailViewControllerDelegate <NSObject>

@optional -(void)issueDetailViewController:(IssueDetailViewController *)vc willDeleteIssue:(Issue *)issue;

@end

@interface IssueDetailViewController : UIViewController


-(instancetype)initWithIssue:(Issue *)issue;

@property (nonatomic, weak) id<IssueDetailViewControllerDelegate> delegate;

@end
