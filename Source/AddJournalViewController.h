//
//  AddJournalViewController.h
//  
//
//  Created by Michal Kučera on 23/11/15.
//
//

#import <UIKit/UIKit.h>

@interface AddJournalViewController : UITableViewController

- (instancetype)initWithIssue:(Issue *)issue;

@property (nonatomic, copy) void (^finishingBlock)(Issue *issue);

@end
