//
//  TicketsViewController.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 16/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
@interface IssuesViewController : MasterMenuViewController
-(void)refershHelp;

-(void)showAddIssueViewController:(id)sender;
@end
