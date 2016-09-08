//
//  AddJournalViewController.m
//
//
//  Created by Michal Kučera on 23/11/15.
//
//

#import "AddJournalViewController.h"
#import "EditPlainCell.h"
#import "EditTextViewCell.h"
#import "EditPickerCell.h"
#import "MultiSectionSelectionTableViewController.h"
#import "EasyRMAlerts.h"
#import <AFNetworking.h>

@interface AddJournalViewController ()

@property (nonatomic, strong) NSDictionary *prototypeCells;
@property (nonatomic, assign) BOOL statusPickerShown;

@property (nonatomic, strong) RACDisposable *validationDisposable;

@property (nonatomic, strong) NSString *commentText;

@property (nonatomic, strong) Issue *originalIssue;
@property (nonatomic, strong) EditedIssue *issue;

@end

@implementation AddJournalViewController

static NSString *const EditPlainCellID = @"EditPushCellID";
static NSString *const EditTextViewCellID = @"EditTextViewCellID";
static NSString *const EditPickerCellID = @"EditPickerCellID";
static NSString *const EditTextFieldCellID = @"EditTextFieldCellID";

- (instancetype)initWithIssue:(Issue *)issue
{
    self = [super init];
    if (self) {
        self.originalIssue = issue;
        self.issue = [[EditedIssue alloc] initWithIssue:issue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dissmisController)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(sendJournal)];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    self.navigationItem.title = NSLocalizedString(@"addComment", nil);
    
    [self.tableView registerClass:[EditPlainCell class] forCellReuseIdentifier:EditPlainCellID];
    [self.tableView registerClass:[EditTextViewCell class] forCellReuseIdentifier:EditTextViewCellID];
    [self.tableView registerClass:[EditPickerCell class] forCellReuseIdentifier:EditPickerCellID];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {//ios 7-, create prototypeCells
        self.prototypeCells = @{
                                EditPlainCellID : [EditPlainCell new]
                                ,EditTextViewCellID : [EditTextViewCell new]
                                ,EditPickerCellID : [EditPickerCell new]
                                };
    }
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    [self validate];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 + self.statusPickerShown;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES]; //force whoever is the first responder to resign
    EditTextViewCell *tfCell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if ([tfCell isKindOfClass:[EditTextViewCell class]]) {
        //fix for dissapearing separator
        [tableView beginUpdates];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView endUpdates];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //---------------------endfix
        [tfCell.textView becomeFirstResponder];
        return;
    }

    
    if (indexPath.row == 0) {
        [self showAssigneeSelectionController:indexPath];
    } else if (indexPath.row == 1) {
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        self.statusPickerShown = !self.statusPickerShown;
        [self showPickerRow:!self.statusPickerShown indexPath:pickerIndexPath];
    }
}

- (void)showPickerRow:(BOOL)isShown indexPath:(NSIndexPath *)path
{
    if (isShown) {
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:path.row-1 inSection:path.section] animated:YES];
    } else {
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) 	return -1;
    
    if (indexPath.row == 2) {
        EditTextViewCell *textViewCell = self.prototypeCells[EditTextViewCellID];
        textViewCell.textView.text = indexPath.row == 1 ? self.issue.subject : self.issue.issueDescription;
        return [self heightOfTextViewCell:textViewCell];
    }
    
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0 ) {
        EditPlainCell *assigneeCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID];
        assigneeCell.leftLabel.text = NSLocalizedString(@"new_task_assignee", @"");
        
        RACSignal *modelSignal = [RACObserve(self, issue.assignedTo) takeUntil:assigneeCell.rac_prepareForReuseSignal];
        RAC(assigneeCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
            if(!value) return [UIColor lightGrayColor];
            return [UIColor darkTextColor];
        }];
        RAC(assigneeCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
            ) = [modelSignal map:^id(id value) {
            return value[@"name"];
        }];
        assigneeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [[RACObserve(self, issue.availableAssignees) takeUntil:assigneeCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
            if([x count]){
                assigneeCell.rightLabel.hidden = NO;
                [assigneeCell.activityIndicator stopAnimating];
                assigneeCell.activityIndicator.hidden = YES;
            }else{
                assigneeCell.rightLabel.hidden = YES;
                [assigneeCell.activityIndicator startAnimating];
                assigneeCell.activityIndicator.hidden = NO;
            }
        }];
        cell = assigneeCell;
    } else if (indexPath.row == 1)  {
        EditPlainCell *statusCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
        statusCell.leftLabel.text = NSLocalizedString(@"new_task_status", @"");
        
        RACSignal *modelSignal = [RACObserve(self, issue.status) takeUntil:statusCell.rac_prepareForReuseSignal];
        RAC(statusCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
            if(!value) return [UIColor lightGrayColor];
            return [UIColor darkTextColor];
        }];
        RAC(statusCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
            ) = [modelSignal map:^id(id value) {
            return value[@"name"];
        }];
        
        [[RACObserve(self, issue.availableStatuses) takeUntil:statusCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
            if(x){
                statusCell.rightLabel.hidden = NO;
                [statusCell.activityIndicator stopAnimating];
                statusCell.activityIndicator.hidden = YES;
                if([x count] == 0){
                    statusCell.leftLabel.textColor = [UIColor lightGrayColor];
                }else{
                    statusCell.leftLabel.textColor = [UIColor darkTextColor];
                }
            }else{
                statusCell.rightLabel.hidden = YES;
                [statusCell.activityIndicator startAnimating];
                statusCell.activityIndicator.hidden = NO;
            }
        }];
        
        cell = statusCell;
        
    } else {
        if (indexPath.row == 2 && self.statusPickerShown) {
            EditPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:EditPickerCellID forIndexPath:indexPath];
            [self configureStatusPickerCell:pickerCell];
            return pickerCell;
        } else {
            EditTextViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
            descCell.textView.placeholder = NSLocalizedString(@"comment_hint", @"");

            @weakify(self)
            [[[descCell.textView.rac_textSignal skip:1] takeUntil:descCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                @strongify(self)
                self.commentText = x; //!!!model must be updated before changing height on ios7
                [UIView performWithoutAnimation:^{
                    [tableView beginUpdates]; //relayout height
                    [tableView deselectRowAtIndexPath:indexPath animated:NO]; //this way, separator doesnt dissapear, TODO: does this break controller logic?
                    [tableView endUpdates];
                }];
            }];
            cell = descCell;
        }
    }
    
    return cell;
}


- (void)sendJournal
{
    [SVProgressHUD show];
	self.navigationItem.rightBarButtonItem.enabled = NO;
    [[[[DataService sharedService] addComment:self.commentText toIssue:self.originalIssue status:self.issue.status[@"value"] assignee:self.issue.assignedTo[@"value"]]  finally:^{
		 self.navigationItem.rightBarButtonItem.enabled = YES;
    }]subscribeNext:^(id x) {
        if (self.finishingBlock) {
            self.finishingBlock(x);
        }
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"title_error", @"")];
	} completed:^{
		[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"sent", @"")];
        [self dissmisController];
	}];
}

-(void)showAssigneeSelectionController:(id)sender
{
    NSArray *sortedAssignees = self.issue.availableAssignees;
    if(sortedAssignees.count > 0){
        MultiSectionSelectionTableViewController *vc = [[MultiSectionSelectionTableViewController alloc] initWithSections:sortedAssignees multipleSelection:NO];
        vc.selectedItems = self.issue.assignedTo ? @[self.issue.assignedTo] : @[];
        [[RACObserve(vc, selectedItems) skip:1] subscribeNext:^(NSArray *x) {
            //		assert(!x.firstObject || [x.firstObject isKindOfClass:[MembershipItem class]]);
            self.issue.assignedTo = x.firstObject;
           [self validate];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
}

-(CGFloat)heightOfTextViewCell:(EditTextViewCell *)textViewCell
{
    [textViewCell setNeedsLayout];
    [textViewCell layoutIfNeeded];
    
    //ios7 textview intrinsic contentsize is bugged, use this magic code instead
    
    // This is the code for iOS 7. contentSize no longer returns the correct value, so
    // we have to calculate it.
    //
    // This is partly borrowed from HPGrowingTextView, but I've replaced the
    // magic fudge factors with the calculated values (having worked out where
    // they came from)
    
    UITextView *textView = textViewCell.textView;
    CGRect frame = textView.bounds;
    
    // Take account of the padding added around the text.
    
    UIEdgeInsets textContainerInsets = textView.textContainerInset;
    UIEdgeInsets contentInsets = textView.contentInset;
    
    CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
    CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
    
    frame.size.width -= leftRightPadding;
    frame.size.height -= topBottomPadding;
    
    NSString *textToMeasure = textView.text;
    if ([textToMeasure hasSuffix:@"\n"])
    {
        textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
    }
    
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
    
    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
    return measuredHeight + 30 + 0.5; //textview + insets + separator
}

-(void)validate
{
    [self.validationDisposable dispose]; //dont do multiple validation requests at the same time, they might come back in wrong order
    self.validationDisposable = [[[DataService sharedService] validateIssue:self.issue] subscribeNext:^(id x) {
        self.issue = x;
        [self.tableView reloadData]; //reloceladSections messes up contentOffset
    } error:^(NSError *error) {
        TRC_OBJ(error);
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if(response && response.statusCode == 500){ //this probably means we used a filter that only works with certain projects. Remove the current filter and reloadData
            [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"server_undefined_error", @"") block:^{
                ;
            }];
        }else{
            [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"errorConnection", @"") block:^{
                ;
            }];
            
        }
    }];
}

- (void)configureStatusPickerCell:(EditPickerCell *)cell
{
    cell.items = self.issue.availableStatuses;
    cell.selectedItem = self.issue.status ?: cell.items.firstObject;
    @weakify(self)
    [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self)
        if(![self.issue.status isEqual:x]){
            self.issue.status = x;
            [self validate];
        }
    }];
}

- (void)dissmisController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
