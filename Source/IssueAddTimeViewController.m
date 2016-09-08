//
//  IssueAddTimeViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 06/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssueAddTimeViewController.h"
#import "EditPlainCell.h"
#import "SingleSectionSelectionTableViewController.h"
#import "EditTextViewCell.h"
#import "EditPickerCell.h"
#import "EditDatePickerCell.h"
#import "EditTextFieldCell.h"
#import "EasyRMAlerts.h"
#import <AFNetworking.h>

@interface IssueAddTimeViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic, strong, readwrite) Issue *issue;
@property (nonatomic, strong) TimeEntryActivity *selectedTimeActivity;
@property (nonatomic, strong) NSManagedObjectContext *context; //hold on to context of self.issue
@property (nonatomic,strong) NSDate *activityDate;
@property (nonatomic, strong) NSIndexPath *pickerIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic) NSNumber *activityTime;
@property (nonatomic, strong) NSString *activityComment;
@property (nonatomic, strong) NSDictionary *prototypeCells;

@property (nonatomic, copy) void (^deletePickerBlock)();
@end

@implementation IssueAddTimeViewController

static NSString *const EditPlainCellID = @"EditPushCellID";
static NSString *const EditTextViewCellID = @"EditTextViewCellID";
static NSString *const EditPickerCellID = @"EditPickerCellID";
static NSString *const EditDatePickerCellID = @"EditDatePickerCellID";
static NSString *const EditTextFieldCellID = @"EditTextFieldCellID";
static NSString *const EditAddFileCellID = @"EditAddFileCellID";

+(NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *f;
    if(!f){
        f = [NSDateFormatter new];
        [f setDateFormat:@"dd.MM.YYYY"];
    }
    return f;
}


+(NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *f;
    if(!f){
        f = [NSNumberFormatter new];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        f.minimumFractionDigits = 2;
        f.maximumFractionDigits = 2;
    }
    return f;
}

-(instancetype)initWithIssue:(Issue *)issue
{
    if(self = [super init]){
        
        self.selectedTimeActivity =  [TimeEntryActivity MR_findFirstByAttribute:@"isDefault"
                                                           withValue:@(1)];
        self.issue = issue;
        self.activityDate = [NSDate date];
        self.activityTime = 0;
        self.context = issue.managedObjectContext;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.issue.subject;
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add_time_done", @"")
 style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonTouch:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.tableView.tableFooterView = [UIView new];
   
    [self.tableView registerClass:[EditPlainCell class] forCellReuseIdentifier:EditPlainCellID];
    [self.tableView registerClass:[EditTextViewCell class] forCellReuseIdentifier:EditTextViewCellID];
    [self.tableView registerClass:[EditPickerCell class] forCellReuseIdentifier:EditPickerCellID];
    [self.tableView registerClass:[EditDatePickerCell class] forCellReuseIdentifier:EditDatePickerCellID];
    [self.tableView registerClass:[EditTextFieldCell class] forCellReuseIdentifier:EditTextFieldCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EditAddFileCellID];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {//ios 7-, create prototypeCells
        self.prototypeCells = @{
                                EditPlainCellID : [EditPlainCell new]
                                ,EditTextViewCellID : [EditTextViewCell new]
                                ,EditPickerCellID : [EditPickerCell new]
                                ,EditDatePickerCellID : [EditDatePickerCell new]
                                ,EditTextFieldCellID : [EditTextFieldCell new]
                                ,EditAddFileCellID : [UITableViewCell new]
                                };
    }

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 44.;
	
	RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACObserve(self, activityTime) map:^id(id value) {
		return @(value != nil);
	}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.selectedIndexPath){
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:NO];
        self.selectedIndexPath = nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 4 + (self.pickerIndexPath && self.pickerIndexPath.section == 0);
        default: return 0;
    }
}

-(void)configureDatePickerCell:(EditDatePickerCell *)cell forModelIndexPath:(NSIndexPath *)modelIndexPath
{
    assert(modelIndexPath.section == 0);
    switch (modelIndexPath.row) {
        case 0:
        {
            cell.selectedDate = self.activityDate;
            @weakify(self)
            [[[RACObserve(cell, selectedDate) skip:1] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self)
                self.activityDate = x;
            }];
        }
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //picker cell
    NSIndexPath *modelIndexPath = indexPath;
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row)
    {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        
        if(self.pickerIndexPath.row == indexPath.row){
            switch (modelIndexPath.section) {
                case 0:
                {
                    EditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:EditDatePickerCellID forIndexPath:indexPath];
                    [self configureDatePickerCell:datePickerCell	forModelIndexPath:modelIndexPath];
                    return datePickerCell;
                }
            }
        }
    }
    //non-picker cells
    UITableViewCell *cell;
    
    switch (modelIndexPath.section) {

        case 0:
        {
            switch (modelIndexPath.row) {
                case 2:
                {
                    EditPlainCell *activityCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
						 activityCell.leftLabel.text = NSLocalizedString(@"activity", @"");
                    RACSignal *modelSignal = [RACObserve(self, selectedTimeActivity.name) takeUntil:activityCell.rac_prepareForReuseSignal];
                    
                    RAC(activityCell, leftLabel.textColor) = [modelSignal map:^id(id value) {
                       // if(!value) return [UIColor lightGrayColor];
                        return [UIColor lightGrayColor];
                    }];
                    RAC(activityCell, rightLabel.text,self.selectedTimeActivity.name) = modelSignal;
                    activityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell = activityCell;
                }
                    break;
                case 0:
                {
                    
                    EditPlainCell *dueDateCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
						 dueDateCell.leftLabel.text = NSLocalizedString(@"task_detail_due_date", @"");

                    dueDateCell.leftLabel.textColor = [UIColor lightGrayColor];
                    //self.issue.dueDate = [NSDate date];
                    RACSignal *modelSignal = [RACObserve(self, activityDate) takeUntil:dueDateCell.rac_prepareForReuseSignal];
//                    RAC(dueDateCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
//                        if(!value) return [UIColor lightGrayColor];
//                        return [UIColor lightGrayColor];
//                    }];
                    RAC(dueDateCell, rightLabel.text) = [modelSignal map:^id(id value) {
							  if(!value) return NSLocalizedString(@"new_task_none", @"");
                        return [[[self class] dateFormatter] stringFromDate:value];
                    }] ;
                    cell = dueDateCell;
                }
                    break;
                case 1:
                {
                    EditTextFieldCell *timeCell = [tableView dequeueReusableCellWithIdentifier:EditTextFieldCellID forIndexPath:indexPath];
                    timeCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
						 timeCell.leftLabel.text = NSLocalizedString(@"add_time_time", @"")
;
						 timeCell.textField.placeholder = NSLocalizedString(@"new_task_none", @"")
;
                    timeCell.leftLabel.textColor = [UIColor lightGrayColor];

                    @weakify(self)
                    [[[timeCell.textField.rac_textSignal skip:1] takeUntil:timeCell.rac_prepareForReuseSignal]  subscribeNext:^(NSString *x) {
                        @strongify(self);
                        if([x componentsSeparatedByString:[[self class] numberFormatter].decimalSeparator].count > 2){
                            x = [x substringToIndex:x.length-1]; //must end with (second) decimal point, remove it
                            timeCell.textField.text = x; //dont allow more than one decimal point
                        }
                        NSNumber *n = [[[self class] numberFormatter] numberFromString:x];
                        self.activityTime= n;
                    }];
                    cell = timeCell;
                }
                    break;
                case 3:
                {
                    EditTextViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
						 descCell.textView.placeholder = NSLocalizedString(@"description", @"");
                   // descCell.textView.text = @"Description";//self.issue.issueDescription;
                    @weakify(self)
                    [[[descCell.textView.rac_textSignal skip:1] takeUntil:descCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        @strongify(self)
                        [UIView performWithoutAnimation:^{  //TODO: this breaks cell separators
                            [tableView beginUpdates]; //relayout height
                            [tableView endUpdates];
                        }];
                        self.activityComment = x;
                    }];
                    cell = descCell;
                }
                    break;
            }
        }
            break;

        default:
            assert(NO);
    }
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath isEqual:self.pickerIndexPath]){
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
   

    EditTextViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[EditTextViewCell class]]) {
        if(self.deletePickerBlock){
            self.deletePickerBlock();
            self.deletePickerBlock = nil;
        }
        [cell.textView becomeFirstResponder];
        return;
    }
    EditTextFieldCell *tfCell = (id)cell;
    if ([tfCell isKindOfClass:[EditTextFieldCell class]]) {
        if(self.deletePickerBlock){
            self.deletePickerBlock();
            self.deletePickerBlock = nil;
        }
        [tfCell.textField becomeFirstResponder];
        return;
    }
    if([indexPath isEqual:self.selectedIndexPath]){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        if(self.deletePickerBlock){
            self.deletePickerBlock();
            self.deletePickerBlock = nil;
        }
        return ;
    }
    
    NSIndexPath *modelIndexPath = indexPath;
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row)
    {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    self.selectedIndexPath = modelIndexPath;
    
    if(self.deletePickerBlock){
        self.deletePickerBlock();
        self.deletePickerBlock = nil;
    }
    
//    if (indexPath.row) {
//        <#statements#>
//    }
    
    switch (modelIndexPath.row) {
        case 0:
        {
            NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:modelIndexPath.row + 1 inSection:modelIndexPath.section];
            self.pickerIndexPath = pickerIndexPath;
            [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
            break;
            
        case 2:
        {

            [self showTimeEntryActivitySelectionController:indexPath];
            break;
        }
            
        default:
            assert(NO);
    }
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    id cell = [self.tableView cellForRowAtIndexPath:pickerIndexPath];
    return [cell isKindOfClass:[EditPickerCell class]] ||[cell isKindOfClass:[EditDatePickerCell class]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    self.selectedIndexPath = nil;
    NSIndexPath *modelIndexPath = indexPath;
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row)
    {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    if([self hasPickerForIndexPath:modelIndexPath]){
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        @weakify(self)
        self.deletePickerBlock = ^{
            @strongify(self)
            self.pickerIndexPath = nil;
            [tableView deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
    }
}

-(void)showTimeEntryActivitySelectionController:(id)sender
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"TimeEntryActivity"];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    fetch.predicate = [NSPredicate predicateWithFormat:@"self.identifier != %@", self.issue.identifier];
    NSArray *sortedIssues = [self.context executeFetchRequest:fetch error:nil];
    SingleSectionSelectionTableViewController *vc = [[SingleSectionSelectionTableViewController alloc] initWithItems:sortedIssues multipleSelection:NO];
    [[RACObserve(vc, selectedItems) skip:1] subscribeNext:^(NSArray *x) {
        assert(!x.firstObject || [x.firstObject isKindOfClass:[TimeEntryActivity class]]);
        self.selectedTimeActivity = x.firstObject;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)doneBarButtonTouch:(id)sender
{
//    TRC_ENTRY;
//    TRC_LOG(@"DONE BUTTON PRESSED");
//    TRC_OBJ(self.activityComment);
//    TRC_OBJ(self.activityTime);
//    TRC_OBJ(self.selectedTimeActivity);
//    TRC_OBJ(self.activityDate);
    if (self.activityTime) {
        //TODO API
		 self.view.userInteractionEnabled = NO;
		 self.navigationItem.rightBarButtonItem.enabled = NO;
		 
        [[[[DataService sharedService] addTimeIssue:self.issue andHours:self.activityTime andDate:self.activityDate andActivity:self.selectedTimeActivity andCommnet:self.activityComment]
			finally:^{
				self.view.userInteractionEnabled = YES;
				self.navigationItem.rightBarButtonItem.enabled = YES;
			}]
         subscribeError:^(NSError *error) {
				TRC_OBJ(error);
				NSString *message;
				if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]){
					NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
					id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
					id errors = [JSON valueForKeyPath:@"errors"];
					if([errors isKindOfClass:[NSArray class]]){
						RACSequence *seq = [[errors rac_sequence] filter:^BOOL(id value) {
							return [value isKindOfClass:[NSString class]];
						}];
						message = [seq.tail foldLeftWithStart:seq.head reduce:^id(id accumulator, id value) {
							return [accumulator stringByAppendingString:[NSString stringWithFormat:@", %@", value]];
						}];
					}
					if(!message){
						message = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
						
					}
				}
				if(!message || [[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
					if(error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey]){
						NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
						message = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"error_response_code", @""), @(response.statusCode)];
					}
				}
				if(!message || [[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
					message = NSLocalizedString(@"errorConnection", @"")
					;
				}
				
				UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"title_error", @"")
																		  message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"")
															 otherButtonTitles:nil];
				[a show];
         } completed:^{
             
             self.issue.spentHours = [NSNumber numberWithFloat:([self.issue.spentHours floatValue] + [self.activityTime floatValue])];
             
             [self.navigationController popViewControllerAnimated:YES];
         }];

    }else{
		 [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"add_time_warning_title", @"")
 andDescription:NSLocalizedString(@"add_time_warning_subtitle", @"") block:^{
            ;
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) 	return -1; //use AutomaticDimension
    
    UITableViewCell *cell; //TODO: code only covers necessary states, test on ios7 after every change
    if([indexPath isEqual:self.pickerIndexPath]){
        cell = self.prototypeCells[EditDatePickerCellID];
    }
    else if(indexPath.section == 0 && indexPath.row == 3){
        EditTextViewCell *textViewCell = [EditTextViewCell new];
        textViewCell.textView.text =  self.activityComment;
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
    if(cell){
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //TRC_OBJ(NSStringFromCGSize([[(id)cell textView] intrinsicContentSize]));
        return size.height + 0.5;
    }
    return 50.;
}




@end
