//
//  IssueAddTimeViewController.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 06/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueAddTimeViewController : UITableViewController
-(instancetype)initWithIssue:(Issue *)issue; //if nil, creates new issue
@property (nonatomic, strong, readonly) Issue *issue;
@end
