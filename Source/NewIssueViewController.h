//
//  EditIssueViewController.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditedIssue.h"

@interface NewIssueViewController : UITableViewController

-(instancetype)init; //if nil, creates new issue
@property (nonatomic, strong, readonly) EditedIssue *issue;

-(instancetype)initWithEditedIssue:(EditedIssue *)editedIssue; //use this for restoring saved issue

@end
