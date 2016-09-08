//
//  EditIssueViewController.h
//  
//
//  Created by Michal Kučera on 15/12/15.
//
//

#import <UIKit/UIKit.h>
#import "EditedIssue.h"

@interface EditIssueViewController : UITableViewController

-(instancetype)initWithIssue:(Issue *)issue; //if nil, creates new issue
@property (nonatomic, strong, readonly) EditedIssue *issue;

-(instancetype)initWithEditedIssue:(EditedIssue *)editedIssue; //use this for restoring saved issue

@end
