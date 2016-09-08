//
//  EditIssueViewController.m
//
//
//  Created by Michal Kučera on 15/12/15.
//
//

#import "EditIssueViewController.h"
#import "EditPlainCell.h"
#import "SingleSectionSelectionTableViewController.h"
#import "MultiSectionSelectionTableViewController.h"
#import "EditTextViewCell.h"
#import "EditPickerCell.h"
#import "EditDatePickerCell.h"
@import MobileCoreServices;
#import "EditTextFieldCell.h"
#import "EditUploadCell.h"
#import <AFNetworking.h>
#import "LabelViewCell.h"
#import "EditSwitchCell.h"
#import "EasyRMAlerts.h"

#define MAIN_SECTION 0
#define TOGGLE_SECION 1
#define SECONDARY_SECTION 2
#define ATTACHMENTS_SECTION 3
#define CUSTOM_FIELDS_SECTION 4

@interface EditIssueViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong, readwrite) EditedIssue *issue;

@property (nonatomic, strong) NSIndexPath *pickerIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, copy) void (^deletePickerBlock)();

@property (nonatomic, strong) NSDictionary *prototypeCells;

@property (nonatomic, assign) NSUInteger pendingUploads;

@property (nonatomic, strong) RACDisposable *validationDisposable;

@property (nonatomic, strong) NSString *commentText;

@property (nonatomic, assign) BOOL showMore;

@end

@implementation EditIssueViewController

static NSString *const EditPlainCellID = @"EditPushCellID";
static NSString *const EditTextViewCellID = @"EditTextViewCellID";
static NSString *const EditPickerCellID = @"EditPickerCellID";
static NSString *const EditDatePickerCellID = @"EditDatePickerCellID";
static NSString *const EditTextFieldCellID = @"EditTextFieldCellID";
static NSString *const EditAddFileCellID = @"EditAddFileCellID";
static NSString *const EditUploadCellID = @"EditUploadCellID";
static NSString *const EditSwitchCellID = @"EditSwitchCellID";
static NSString *const LabelViewCellID = @"LabelViewCellID";

+(NSNumberFormatter *)intFormatter
{
    static NSNumberFormatter *f;
    if(!f){
        f = [NSNumberFormatter new];
        f.minimumFractionDigits = 0;
        f.maximumFractionDigits = 0;
    }
    return f;
}


+(NSNumberFormatter *)floatFormatter
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

-(void)setIssue:(EditedIssue *)issue
{
    NSArray *oldFileUploads = _issue.fileUploads; //dont forget running fileUploads when new issue comes in from validation API
    if(oldFileUploads.count > 0 && issue.fileUploads.count == 0) {
        [issue.fileUploads addObjectsFromArray:oldFileUploads];
    }
    _issue = issue;
}


-(instancetype)initWithIssue:(Issue *)issue
{
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        self.issue = [[EditedIssue alloc] initWithIssue:issue];
    }
    return self;
}

-(instancetype)initWithEditedIssue:(EditedIssue *)editedIssue
{
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        assert(editedIssue);
        assert(editedIssue.identifier);
        self.issue = editedIssue;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"menu_title_edit_task", @"");
    
    self.showMore = NO;
    
    dispatch_once(&onceToken, ^{
        textViewFields = @[@"easy_google_map_address", @"email", @"link", @"text", @"string"];
        intFields = @[@"amount", @"int"];
        floatFields = @[@"float"];
        listFields = @[@"list", @"version", @"user", @"value_tree"];
        boolFields = @[@"bool"];
        dateFields = @[@"date", @"datetime"];
        percentFields = @[@"easy_percent"];
    });
    
    
    [self.tableView registerClass:[EditPlainCell class] forCellReuseIdentifier:EditPlainCellID];
    [self.tableView registerClass:[LabelViewCell class] forCellReuseIdentifier:LabelViewCellID];
    [self.tableView registerClass:[EditTextViewCell class] forCellReuseIdentifier:EditTextViewCellID];
    [self.tableView registerClass:[EditPickerCell class] forCellReuseIdentifier:EditPickerCellID];
    [self.tableView registerClass:[EditDatePickerCell class] forCellReuseIdentifier:EditDatePickerCellID];
    [self.tableView registerClass:[EditTextFieldCell class] forCellReuseIdentifier:EditTextFieldCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EditAddFileCellID];
    [self.tableView registerClass:[EditUploadCell class] forCellReuseIdentifier:EditUploadCellID];
    [self.tableView registerClass:[EditSwitchCell class]  forCellReuseIdentifier:EditSwitchCellID];
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {//ios 7-, create prototypeCells
        self.prototypeCells = @{
                                EditPlainCellID : [EditPlainCell new]
                                ,EditTextViewCellID : [EditTextViewCell new]
                                ,EditPickerCellID : [EditPickerCell new]
                                ,EditDatePickerCellID : [EditDatePickerCell new]
                                ,EditTextFieldCellID : [EditTextFieldCell new]
                                ,EditAddFileCellID : [UITableViewCell new]
                                ,EditUploadCellID : [EditUploadCell new]
                                };
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
    RAC(saveButtonItem, enabled) = [RACObserve(self, pendingUploads) not];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.navigationController.navigationBar.translucent = NO; //should be done from here but i dont care
    
    [self validate];
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
    if (self.showMore) {
        return 5;
    } else {
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MAIN_SECTION: return 6 + (self.pickerIndexPath && self.pickerIndexPath.section == MAIN_SECTION); // Assignee, Status, Priority, Due Date, Done, Note/Comment + 1 if there is picker in section (for Due Date)
        case TOGGLE_SECION: return 1; // Show more/less button
        case SECONDARY_SECTION: return 8 + (self.pickerIndexPath && self.pickerIndexPath.section == SECONDARY_SECTION); // Project, Subject, Description, Tracker, Start Date, Estimated Time, Milestone, Category + 1 if there is picker in section (for Due Date or Start Date)
        case ATTACHMENTS_SECTION: return 1 + self.issue.fileUploads.count; //TODO: +current attachments
        case CUSTOM_FIELDS_SECTION: return self.issue.customFields.count + (self.pickerIndexPath && self.pickerIndexPath.section == CUSTOM_FIELDS_SECTION);
        default: return 0;
    }
}

-(BOOL)canOpenPickerForModelIndexPath:(NSIndexPath *)modelIndexPath
{
    NSArray *items;
    switch (modelIndexPath.section) {
        case MAIN_SECTION:
            // Main section
            switch (modelIndexPath.row) {
                case 1: // Status
                    return self.issue.availableStatuses.count;
                case 2: // Priority
                    return self.issue.availablePriorities.count;
                case 3: // Due Date
                case 4: // Done
                    return YES;
                default:
                    return NO;
            }
        case SECONDARY_SECTION:
            // Hideable section
            switch (modelIndexPath.row) {
                case 3: // Tracker
                    return self.issue.availableTrackers.count;
                case 4: // Start Date
                    return YES;
                case 7: // Category
                    return self.issue.availableCategories.count + 1;
                default:
                    return NO;
            }
            
        default:
            break;
    }
    
    return items.count > 0;
}

-(void)configurePickerCell:(EditPickerCell *)cell forModelIndexPath:(NSIndexPath *)modelIndexPath
{
    switch (modelIndexPath.section) {
        case MAIN_SECTION:
            switch (modelIndexPath.row) {
                case 1: // Status
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
                    break;
                    
                case 2: // Priority
                {
                    cell.items = self.issue.availablePriorities;
                    cell.selectedItem = self.issue.priority ?: cell.items.firstObject;
                    @weakify(self)
                    [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                        @strongify(self)
                        if(![self.issue.priority isEqual:x]){
                            self.issue.priority = x;
                            [self validate];
                        }
                    }];
                }
                    break;
                    
                case 4: // Done
                {
                    cell.items = [self doneRatioEntries];
                    cell.selectedItem = self.issue.doneRatio ?: cell.items.firstObject;
                    @weakify(self)
                    [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                        @strongify(self)
                        if(![self.issue.doneRatio isEqual:x]){
                            self.issue.doneRatio = x;
                            [self validate];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
            break;
            
        case SECONDARY_SECTION:
            switch (modelIndexPath.row) {
                case 3: // Tracker
                {
                    cell.items = self.issue.availableTrackers;
                    cell.selectedItem = self.issue.tracker ?: cell.items.firstObject;
                    @weakify(self)
                    [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal ] subscribeNext:^(id x) {
                        @strongify(self)
                        if(![self.issue.tracker isEqual:x]){
                            self.issue.tracker = x;
                            [self validate];
                        }
                    }];
                }
                    break;
                case 7:
                {
                    cell.items = [@[@{@"name":NSLocalizedString(@"none", nil)}] arrayByAddingObjectsFromArray:self.issue.availableCategories];
                    cell.selectedItem = self.issue.category ?: cell.items.firstObject;
                    @weakify(self)
                    [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                        @strongify(self)
                        if(![self.issue.category isEqual:x]){
                            self.issue.category = x;
                            [self validate];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
            break;
            
        case CUSTOM_FIELDS_SECTION: // Custom Fields
        {
            id cf = self.issue.customFields[modelIndexPath.row];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:11];
            for (NSUInteger i = 0; i <= 100; i+=10) {
                [items addObject:@(i)];
            }
            cell.items = [items copy];
            cell.suffix = @" %";
            cell.selectedItem = cf[@"value"] != NSNull.null ? cf[@"value"] : nil;
            @weakify(self)
            [[RACObserve(cell, selectedItem) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self)
                if(![cf[@"value"] isEqual:x]){
                    cf[@"value"] = x ?: NSNull.null;
                    EditPlainCell *aboveCell = (id)[self.tableView cellForRowAtIndexPath:modelIndexPath];
                    aboveCell.rightLabel.text = cf[@"value"] != NSNull.null ? [[cf[@"value"] stringValue] stringByAppendingString:NSLocalizedString(@"%", @"")] : NSLocalizedString(@"new_task_none", @"");
                    ;
                }
            }];
            
        }
            break;
        default:
            break;
    }
}

-(void)configureDatePickerCell:(EditDatePickerCell *)cell forModelIndexPath:(NSIndexPath *)modelIndexPath
{
    switch (modelIndexPath.section) {
        case MAIN_SECTION:
            if (modelIndexPath.row == 3) { // Due Date
                cell.selectedDate = self.issue.dueDate  ?: [NSDate date];
                @weakify(self)
                [[RACObserve(cell, selectedDate) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                    @strongify(self)
                    if(![x isEqual:self.issue.dueDate]){
                        self.issue.dueDate = x;
                        [self validate];
                    }
                }];
            }
            break;
        case SECONDARY_SECTION:
            if (modelIndexPath.row == 4) { // Start Date
                cell.selectedDate = self.issue.startDate ?: [NSDate date];
                @weakify(self)
                [[RACObserve(cell, selectedDate) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                    @strongify(self)
                    if (![x isEqual:self.issue.startDate]) {
                        self.issue.startDate = x;
                        [self validate];
                    }
                }];
            }
            break;
        case CUSTOM_FIELDS_SECTION: // Custom Fields
        {
            id cf = self.issue.customFields[modelIndexPath.row];
            assert([cf[@"field_format"] isEqualToString:@"date"]);
            cell.selectedDate = cf[@"value"] != NSNull.null ? cf[@"value"] : [NSDate date];
            @weakify(self)
            [[RACObserve(cell, selectedDate) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self)
                if(![x isEqual:cf[@"value"]]){
                    cf[@"value"] = x ?: NSNull.null;
                    EditPlainCell *aboveCell = (id)[self.tableView cellForRowAtIndexPath:modelIndexPath];
                    aboveCell.rightLabel.text = [NSDateFormatter localizedStringFromDate:x dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
                    aboveCell.rightLabel.textColor = [UIColor darkTextColor];
                }
            }];
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //picker cell
    NSIndexPath *modelIndexPath = indexPath;
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row) {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        
        if(self.pickerIndexPath.row == indexPath.row){
            if (modelIndexPath.section == CUSTOM_FIELDS_SECTION) {
                // Custom fields section
                id cf = self.issue.customFields[modelIndexPath.row];
                if ([percentFields containsObject:cf[@"field_format"]]) {
                    EditPickerCell *pickerCell = [ tableView dequeueReusableCellWithIdentifier:EditPickerCellID forIndexPath:indexPath];
                    [self configurePickerCell:pickerCell forModelIndexPath:modelIndexPath];
                    return pickerCell;
                } else if([dateFields containsObject:cf[@"field_format"]]) {
                    EditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:EditDatePickerCellID forIndexPath:indexPath];
                    [self configureDatePickerCell:datePickerCell forModelIndexPath:modelIndexPath];
                    return datePickerCell;
                } else {
                    assert(NO);
                }
            } else if (modelIndexPath.section == MAIN_SECTION) {
                // Done, Status, Priority
                if (modelIndexPath.row == 3) {
                    EditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:EditDatePickerCellID forIndexPath:indexPath];
                    [self configureDatePickerCell:datePickerCell forModelIndexPath:modelIndexPath];
                    return datePickerCell;
                } else {
                    // Due date
                    EditPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:EditPickerCellID forIndexPath:indexPath];
                    [self configurePickerCell:pickerCell forModelIndexPath:modelIndexPath];
                    return pickerCell;
                }
            } else if (modelIndexPath.section == SECONDARY_SECTION) {
                if (modelIndexPath.row != 4) {
                    // Times, milestone and category
                    EditPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:EditPickerCellID forIndexPath:indexPath];
                    [self configurePickerCell:pickerCell forModelIndexPath:modelIndexPath];
                    return pickerCell;
                } else {
                    // Start Date
                    EditDatePickerCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:EditDatePickerCellID forIndexPath:indexPath];
                    [self configureDatePickerCell:datePickerCell forModelIndexPath:modelIndexPath];
                    return datePickerCell;
                }
            }
        }
    }
    //non-picker cells
    UITableViewCell *cell;
    
    switch (modelIndexPath.section) {
        case MAIN_SECTION: // Assignee, Status, Priority, Due Date, Done, Note/Comment + 1 for more/less button
            switch (modelIndexPath.row) {
                case 0: // Assignee
                {
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
                }
                    break;
                case 1: // Status
                {
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
                    
                }
                    break;
                    
                case 2: // Priority
                {
                    EditPlainCell *priorityCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    priorityCell.leftLabel.text = NSLocalizedString(@"new_task_priority", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.priority) takeUntil:priorityCell.rac_prepareForReuseSignal];
                    RAC(priorityCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(priorityCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return value[@"name"];
                    }];
                    
                    [[RACObserve(self, issue.availablePriorities) takeUntil:priorityCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if(x){
                            priorityCell.rightLabel.hidden = NO;
                            [priorityCell.activityIndicator stopAnimating];
                            priorityCell.activityIndicator.hidden = YES;
                            if([x count] == 0){
                                priorityCell.leftLabel.textColor = [UIColor lightGrayColor];
                            }else{
                                priorityCell.leftLabel.textColor = [UIColor darkTextColor];
                            }
                        }else{
                            priorityCell.rightLabel.hidden = YES;
                            [priorityCell.activityIndicator startAnimating];
                            priorityCell.activityIndicator.hidden = NO;
                        }
                    }];
                    
                    cell = priorityCell;
                    
                }
                    break;
                    
                case 3: // Due Date
                {
                    
                    EditPlainCell *dueDateCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    dueDateCell.leftLabel.text = NSLocalizedString(@"new_task_due_date", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.dueDate) takeUntil:dueDateCell.rac_prepareForReuseSignal];
                    RAC(dueDateCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(dueDateCell, rightLabel.text) = [modelSignal map:^id(id value) {
                        if(!value) return NSLocalizedString(@"new_task_none", @"");
                        
                        return [NSDateFormatter localizedStringFromDate:value dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
                    }] ;
                    cell = dueDateCell;
                }
                    break;
                    
                case 4: // Done
                {
                    EditPlainCell *doneCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    doneCell.leftLabel.text = NSLocalizedString(@"new_task_done", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.doneRatio) takeUntil:doneCell.rac_prepareForReuseSignal];
                    RAC(doneCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(doneCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return [NSString stringWithFormat:@"%@%%", value];
                    }];
                    
                    [[RACObserve(self, issue.doneRatio) takeUntil:doneCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if(x){
                            doneCell.rightLabel.hidden = NO;
                            [doneCell.activityIndicator stopAnimating];
                            doneCell.activityIndicator.hidden = YES;
                        }else{
                            doneCell.rightLabel.hidden = YES;
                            [doneCell.activityIndicator startAnimating];
                            doneCell.activityIndicator.hidden = NO;
                        }
                    }];
                    
                    
                    cell = doneCell;
                    
                }
                    break;
                    
                case 5: // Note/Comment
                {
                    EditTextViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
                    descCell.textView.placeholder = NSLocalizedString(@"comment_hint", @"");
                    if (self.issue.notes.length > 0) {
                        descCell.textView.text = self.issue.notes;
                    }
                    @weakify(self)
                    [[[descCell.textView.rac_textSignal skip:1] takeUntil:descCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        @strongify(self)
                        self.issue.notes = x; //!!!model must be updated before changing height on ios7
                        [UIView performWithoutAnimation:^{
                            [tableView beginUpdates]; //relayout height
                            [tableView deselectRowAtIndexPath:indexPath animated:NO]; //this way, separator doesnt dissapear, TODO: does this break controller logic?
                            [tableView endUpdates];
                        }];
                    }];
                    cell = descCell;
                }
                    break;
                    
            }
            break;
        case TOGGLE_SECION: // More less button
        {
            LabelViewCell *labelCell = [tableView dequeueReusableCellWithIdentifier:LabelViewCellID forIndexPath:indexPath];
            [labelCell setLessMode:self.showMore];
            cell = labelCell;
        }
            break;
        case SECONDARY_SECTION: // Project, Subject, Description, Tracker, Start Date, Estimated Time, Milestone, Category
            switch (modelIndexPath.row) {
                case 0: // Project
                {
                    EditPlainCell *projectCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    projectCell.leftLabel.text = NSLocalizedString(@"new_task_project", @"")
                    ;
                    RACSignal *modelSignal = [RACObserve(self, issue.project) takeUntil:projectCell.rac_prepareForReuseSignal];
                    RAC(projectCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(projectCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return value[@"name"];
                    }];
                    projectCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    [[RACObserve(self, issue.availableProjects) takeUntil:projectCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if([x count]){
                            projectCell.rightLabel.hidden = NO;
                            [projectCell.activityIndicator stopAnimating];
                            projectCell.activityIndicator.hidden = YES;
                        }else{
                            projectCell.rightLabel.hidden = YES;
                            [projectCell.activityIndicator startAnimating];
                            projectCell.activityIndicator.hidden = NO;
                        }
                    }];
                    
                    cell = projectCell;
                }
                    break;
                    
                case 1: // Subject
                {
                    EditTextViewCell *subjectCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
                    subjectCell.textView.placeholder = NSLocalizedString(@"new_task_subject", @"");
                    
                    subjectCell.textView.text = self.issue.subject;
                    @weakify(self)
                    [[[subjectCell.textView.rac_textSignal skip:1] takeUntil:subjectCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        @strongify(self)
                        self.issue.subject = x;//!!!model must be updated before changing height on ios7
                        [UIView performWithoutAnimation:^{
                            [tableView beginUpdates]; //relayout height
                            [tableView deselectRowAtIndexPath:indexPath animated:NO]; //this way, separator doesnt dissapear, TODO: does this break controller logic?
                            [tableView endUpdates];
                        }];
                    }];
                    cell = subjectCell;
                }
                    break;
                    
                case 2: // Description
                {
                    EditTextViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
                    descCell.textView.placeholder = NSLocalizedString(@"new_task_description", @"");
                    
                    descCell.textView.text = self.issue.issueDescription;
                    @weakify(self)
                    [[[descCell.textView.rac_textSignal skip:1] takeUntil:descCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        @strongify(self)
                        self.issue.issueDescription = x; //!!!model must be updated before changing height on ios7
                        [UIView performWithoutAnimation:^{
                            [tableView beginUpdates]; //relayout height
                            [tableView deselectRowAtIndexPath:indexPath animated:NO]; //this way, separator doesnt dissapear, TODO: does this break controller logic?
                            [tableView endUpdates];
                        }];
                    }];
                    cell = descCell;
                }
                    break;
                    
                case 3: // Tracker
                {
                    EditPlainCell *trackerCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    trackerCell.leftLabel.text = NSLocalizedString(@"new_task_tracker", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.tracker) takeUntil:trackerCell.rac_prepareForReuseSignal];
                    RAC(trackerCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(trackerCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return value[@"name"];
                    }];
                    
                    [[RACObserve(self, issue.availableTrackers) takeUntil:trackerCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if(x){
                            trackerCell.rightLabel.hidden = NO;
                            [trackerCell.activityIndicator stopAnimating];
                            trackerCell.activityIndicator.hidden = YES;
                            if([x count] == 0){
                                trackerCell.leftLabel.textColor = [UIColor lightGrayColor];
                            }else{
                                trackerCell.leftLabel.textColor = [UIColor darkTextColor];
                                if (!self.issue.tracker) {
                                    self.issue.tracker = [x firstObject];
                                }
                            }
                        }else{
                            trackerCell.rightLabel.hidden = YES;
                            [trackerCell.activityIndicator startAnimating];
                            trackerCell.activityIndicator.hidden = NO;
                        }
                    }];
                    
                    
                    cell = trackerCell;
                    
                }
                    break;
                case 4: //  Start Date
                {
                    EditPlainCell *startDateCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    startDateCell.leftLabel.text = NSLocalizedString(@"new_task_start_date", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.startDate) takeUntil:startDateCell.rac_prepareForReuseSignal];
                    RAC(startDateCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    
                    RAC(startDateCell, rightLabel.text) = [modelSignal map:^id(id value) {
                        if(!value) return NSLocalizedString(@"new_task_none", @"")
                            ;
                        return [NSDateFormatter localizedStringFromDate:value dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
                    }] ;
                    cell = startDateCell;
                }
                    break;
                case 5: // Estimated Time
                {
                    EditTextFieldCell *estimatedTimeCell = [tableView dequeueReusableCellWithIdentifier:EditTextFieldCellID forIndexPath:indexPath];
                    estimatedTimeCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    estimatedTimeCell.leftLabel.text = NSLocalizedString(@"new_task_estimated_time", @"");
                    
                    estimatedTimeCell.textField.placeholder = NSLocalizedString(@"new_task_none", @"");
                    
                    NSNumber *estimatedHours = self.issue.estimatedHours;
                    estimatedTimeCell.textField.text = [[[self class] floatFormatter] stringFromNumber:estimatedHours];
                    @weakify(self)
                    [[[estimatedTimeCell.textField.rac_textSignal skip:1] takeUntil:estimatedTimeCell.rac_prepareForReuseSignal]  subscribeNext:^(NSString *x) {
                        @strongify(self);
                        if([x componentsSeparatedByString:[[self class] floatFormatter].decimalSeparator].count > 2){
                            x = [x substringToIndex:x.length-1]; //must end with (second) decimal point, remove it
                            estimatedTimeCell.textField.text = x; //dont allow more than one decimal point
                        }
                        NSNumber *n = [[[self class] floatFormatter] numberFromString:x];
                        self.issue.estimatedHours = n;
                    }];
                    cell = estimatedTimeCell;
                }
                    break;
                case 6: // Milestone
                {
                    EditPlainCell *milestoneCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID];
                    milestoneCell.leftLabel.text = NSLocalizedString(@"new_task_milestone", @"");
                    
                    RACSignal *modelSignal = [RACObserve(self, issue.fixedVersion) takeUntil:milestoneCell.rac_prepareForReuseSignal];
                    RAC(milestoneCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(milestoneCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return value[@"name"];
                    }];
                    milestoneCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    [[RACObserve(self, issue.availableFixedVersions) takeUntil:milestoneCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if(x == nil || [x count]){
                            milestoneCell.rightLabel.hidden = NO;
                            [milestoneCell.activityIndicator stopAnimating];
                            milestoneCell.activityIndicator.hidden = YES;
                        }else{
                            milestoneCell.rightLabel.hidden = YES;
                            [milestoneCell.activityIndicator startAnimating];
                            milestoneCell.activityIndicator.hidden = NO;
                        }
                        if(x == nil){
                            milestoneCell.leftLabel.textColor = [UIColor lightGrayColor];
                        }else{
                            milestoneCell.leftLabel.textColor = [UIColor darkTextColor];
                        }
                    }];
                    
                    
                    cell = milestoneCell;
                }
                    break;
                case 7: // Category
                {
                    EditPlainCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                    categoryCell.leftLabel.text = NSLocalizedString(@"new_task_category", @"")
                    ;
                    RACSignal *modelSignal = [RACObserve(self, issue.category) takeUntil:categoryCell.rac_prepareForReuseSignal];
                    RAC(categoryCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                        if(!value) return [UIColor lightGrayColor];
                        return [UIColor darkTextColor];
                    }];
                    RAC(categoryCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")
                        ) = [modelSignal map:^id(id value) {
                        return value[@"name"];
                    }];
                    
                    [[RACObserve(self, issue.availableCategories) takeUntil:categoryCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                        if(x){
                            categoryCell.rightLabel.hidden = NO;
                            [categoryCell.activityIndicator stopAnimating];
                            categoryCell.activityIndicator.hidden = YES;
                            if([x count] == 0){
                                categoryCell.leftLabel.textColor = [UIColor lightGrayColor];
                            }else{
                                categoryCell.leftLabel.textColor = [UIColor darkTextColor];
                            }
                        }else{
                            categoryCell.rightLabel.hidden = YES;
                            [categoryCell.activityIndicator startAnimating];
                            categoryCell.activityIndicator.hidden = NO;
                        }
                    }];
                    
                    cell = categoryCell;
                    
                }
                    break;
                default:
                    break;
            }
            break;
        case ATTACHMENTS_SECTION: // Attachments
        {
            if(modelIndexPath.row == [self tableView:tableView numberOfRowsInSection:ATTACHMENTS_SECTION]-1){ //last
                UITableViewCell *addFileCell = [tableView dequeueReusableCellWithIdentifier:EditAddFileCellID];
                addFileCell.textLabel.text = NSLocalizedString(@"add_attachment", @"");
                addFileCell.textLabel.textColor = [UIColor lightGrayColor];
                addFileCell.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"accessoryViewAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                cell = addFileCell;
            }else{
                EditUploadCell *uploadCell = [self.tableView dequeueReusableCellWithIdentifier:EditUploadCellID forIndexPath:indexPath];
                FileUpload *fileUpload = [self.issue.fileUploads objectAtIndex:modelIndexPath.row];
                if(fileUpload.token){
                    uploadCell.label.text = fileUpload.filename;
                    uploadCell.progressView.hidden = YES;
                }else{
                    uploadCell.label.hidden = YES;
                    uploadCell.label.text = fileUpload.filename;
                    RACSignal *taskIdSignal = [[RACObserve(fileUpload, uploadTaskIdentifier) takeUntil:uploadCell.rac_prepareForReuseSignal] ignore:nil];
                    RAC(uploadCell.progressView, progress, @(0.)) = [[[[[[[[[[[taskIdSignal flattenMap:^RACStream *(id value) {
                        return [[DataService sharedService].uploadDictionary rac_valuesAndChangesForKeyPath:[NSString stringWithFormat:@"%@.%@", value, ProgressKey] options:NSKeyValueObservingOptionInitial observer:self];
                    }] map:^RACStream *(id value) {
                        return [value first];
                    }]
                                                                             ignore:nil] take:1] flatten]
                                                                          map:^id(NSDictionary *progress) {
                                                                              return @([progress[TotalBytesSentKey] unsignedIntegerValue] / (double)[progress[TotalBytesExpectedKey] unsignedIntegerValue]);
                                                                          }] deliverOnMainThread]
                                                                        doError:^(NSError *error) {
                                                                            NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                                                            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                                                                            NSString *errorString = [JSON[@"errors"] firstObject];
                                                                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"title_error", @"") message:errorString delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
                                                                            [av show];
                                                                            [self.issue.fileUploads removeObject:fileUpload];
                                                                            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                            ;
                                                                        } ]
                                                                       finally:^{
                                                                           uploadCell.progressView.hidden = YES;
                                                                           uploadCell.label.hidden = NO;
                                                                       }]
                                                                      catchTo:[RACSignal return:nil]] takeUntil:uploadCell.rac_prepareForReuseSignal];
                }
                cell = uploadCell;
            }
        }
            break;
        case CUSTOM_FIELDS_SECTION: // Custom fileds section
        {
            NSMutableDictionary *cf = self.issue.customFields[modelIndexPath.row];
            NSString *fieldFormat = cf[@"field_format"];
            if([textViewFields containsObject:fieldFormat]){
                EditTextViewCell *tvCell = [tableView dequeueReusableCellWithIdentifier:EditTextViewCellID forIndexPath:indexPath];
                tvCell.textView.placeholder = cf[@"name"];
                
                NSString *content = cf[@"value"] == NSNull.null ? @"" : cf[@"value"];
                NSString *prefix = [cf[@"name"] stringByAppendingString:@":\n"];
                tvCell.textView.text = [prefix stringByAppendingString:content];
                @weakify(tvCell) //paranoia
                [[[tvCell.textView.rac_textSignal skip:1] takeUntil:tvCell.rac_prepareForReuseSignal]  subscribeNext:^(id x) {
                    @strongify(tvCell)
                    if(![x containsString:prefix]) {
                        x = prefix;
                        tvCell.textView.text = x;
                    }
                    NSString *content = [x substringFromIndex:prefix.length];
                    cf[@"value"] = [content length] > 0 ? content : NSNull.null;//!!!model must be updated before changing height on ios7
                    [UIView performWithoutAnimation:^{
                        [tableView beginUpdates]; //relayout height
                        [tableView deselectRowAtIndexPath:indexPath animated:NO]; //this way, separator doesnt dissapear, TODO: does this break controller logic?
                        [tableView endUpdates];
                    }];
                }];
                cell = tvCell;
            }else if([intFields containsObject:cf[@"field_format"]]){
                EditTextFieldCell *tfCell = [tableView dequeueReusableCellWithIdentifier:EditTextFieldCellID forIndexPath:indexPath];
                tfCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                tfCell.leftLabel.text = cf[@"name"];
                tfCell.textField.placeholder = NSLocalizedString(@"new_task_none", @"");
                tfCell.textField.text = cf[@"value"] != NSNull.null ? [[[self class] intFormatter] stringFromNumber:cf[@"value"]] :nil;
                @weakify(self)
                [[[tfCell.textField.rac_textSignal skip:1] takeUntil:tfCell.rac_prepareForReuseSignal]  subscribeNext:^(NSString *x) {
                    @strongify(self)
                    NSNumber *n = [[[self class] intFormatter] numberFromString:x];
                    cf[@"value"] = n ?: NSNull.null;
                }];
                cell = tfCell;
            }
            else if([floatFields containsObject:cf[@"field_format"]]){
                EditTextFieldCell *tfCell = [tableView dequeueReusableCellWithIdentifier:EditTextFieldCellID forIndexPath:indexPath];
                tfCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                tfCell.leftLabel.text = cf[@"name"];
                tfCell.textField.placeholder = NSLocalizedString(@"new_task_none", @"");
                tfCell.textField.text = cf[@"value"] != NSNull.null ? [[[self class] floatFormatter] stringFromNumber:cf[@"value"]] :nil;
                @weakify(self)
                [[[tfCell.textField.rac_textSignal skip:1] takeUntil:tfCell.rac_prepareForReuseSignal]  subscribeNext:^(NSString *x) {
                    @strongify(self);
                    if([x componentsSeparatedByString:[[self class] floatFormatter].decimalSeparator].count > 2){
                        x = [x substringToIndex:x.length-1]; //must end with (second) decimal point, remove it
                        tfCell.textField.text = x; //dont allow more than one decimal point
                    }
                    NSNumber *n = [[[self class] floatFormatter] numberFromString:x];
                    cf[@"value"] = n ?: NSNull.null;
                }];
                cell = tfCell;
            }
            else if([listFields containsObject:cf[@"field_format"]]){
                EditPlainCell *plainCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID];
                plainCell.leftLabel.text = cf[@"name"];
                plainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                RACSignal *modelSignal = [[[RACSignal return:cf] takeUntil:plainCell.rac_prepareForReuseSignal] map:^id(id cf){
                    NSArray *value = (cf[@"value"] != NSNull.null ? cf[@"value"] : nil);
                    NSArray *availableValues = [[[self.issue.availableCustomFields.rac_sequence filter:^BOOL(id value) {
                        return [value[@"id"] isEqual:cf[@"id"]];
                    }].array.first[@"values"] rac_sequence] filter:^BOOL(id availableCf) {
                        return [value containsObject:availableCf[@"value"]];
                    }].array;
                    RACSequence *values;
                    if(value.count == availableValues.count){
                        values = [[availableValues rac_sequence] map:^id(id availableCf) {
                            return availableCf[@"name"];
                        }];
                    }else{
                        values = [value rac_sequence];
                    }
                    NSString *res = [[values tail] foldLeftWithStart:[values head] reduce:^id(id accumulator, id next) {
                        return [NSString stringWithFormat:@"%@, %@", accumulator, next];
                    }];
                    if([res isEqualToString:@""]){ //map empty string to nil to be able to use 'RAC nil value state'
                        res = nil;
                    }
                    return res;
                }];//done this way to be consistent with other reactive code, but this doesnt really observe self.issue.customFields[row]. Also, takeUntil is useless here.
                RAC(plainCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                    if(!value) return [UIColor lightGrayColor];
                    return [UIColor darkTextColor];
                }];
                RAC(plainCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")) = modelSignal;
                cell = plainCell;
            }
            else if ([boolFields containsObject:cf[@"field_format"]]){
                EditSwitchCell *swCell = [tableView dequeueReusableCellWithIdentifier:EditSwitchCellID forIndexPath:indexPath];
                swCell.leftLabel.text = cf[@"name"];
                BOOL value = [cf[@"value"] boolValue]; //cf[@"value"] cant be NSNull.null, we always assign a value when creating EditedIssue, nil -> NO
                swCell.rightSwitch.on = value;
                [[swCell.rightSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    cf[@"value"] = @([x isOn]);
                }];
                cell = swCell;
            }
            else if ([dateFields containsObject:cf[@"field_format"]]){
                EditPlainCell *plainCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                plainCell.leftLabel.text = cf[@"name"];
                
                RACSignal *modelSignal = [[[RACSignal return:cf] takeUntil:plainCell.rac_prepareForReuseSignal] map:^id(id value) {
                    if(value[@"value"] == NSNull.null) return nil;
                    if([cf[@"field_format"] isEqualToString:@"datetime"]){
                        return [NSDateFormatter localizedStringFromDate:value[@"value"] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
                    }else{
                        return [NSDateFormatter localizedStringFromDate:value[@"value"] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
                    }
                }] ;
                
                RAC(plainCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                    if(!value || [cf[@"field_format"] isEqualToString:@"datetime"]) return [UIColor lightGrayColor]; //datetime isnt editable, show as disabled
                    return [UIColor darkTextColor];
                }];
                RAC(plainCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")) = modelSignal;
                if([cf[@"field_format"] isEqualToString:@"datetime"]) {
                    plainCell.leftLabel.textColor = [UIColor lightGrayColor];
                }
                cell = plainCell;
            }
            else if ([percentFields containsObject:cf[@"field_format"]]){
                EditPlainCell *plainCell = [tableView dequeueReusableCellWithIdentifier:EditPlainCellID forIndexPath:indexPath];
                plainCell.leftLabel.text = cf[@"name"];
                RACSignal *modelSignal = [[RACSignal return:cf[@"value"]] takeUntil:plainCell.rac_prepareForReuseSignal];
                
                RAC(plainCell, rightLabel.textColor) = [modelSignal map:^id(id value) {
                    if(!value) return [UIColor lightGrayColor];
                    return [UIColor darkTextColor];
                }];
                RAC(plainCell, rightLabel.text, NSLocalizedString(@"new_task_none", @"")) = [modelSignal map:^id(id value) {
                    return value != NSNull.null ? [[value stringValue] stringByAppendingString:NSLocalizedString(@"%", @"")] : nil;
                }];
                cell = plainCell;
            }
            if(!cell){
                assert(NO);
            }
        }
            break;
        default:
            assert(NO);
    }
    
    if([indexPath isEqual:self.selectedIndexPath]){
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

static NSArray *listFields;
static NSArray *dateFields;
static NSArray *percentFields;
static NSArray *textViewFields;
static NSArray *intFields;
static NSArray *floatFields;
static NSArray *boolFields;
static dispatch_once_t onceToken;


-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath isEqual:self.pickerIndexPath]){
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES]; //force whoever is the first responder to resign
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // Toggle to show more
        self.showMore = !self.showMore;
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        [tableView reloadData];
        return;
    }
    
    EditTextViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[EditTextViewCell class]]) {
        if(self.deletePickerBlock){
            self.deletePickerBlock();
            self.deletePickerBlock = nil;
        }
        
        //fix for dissapearing separator
        [tableView beginUpdates];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView endUpdates];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //---------------------endfix
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
    EditSwitchCell *swCell = (id)cell;
    if ([swCell isKindOfClass:[EditSwitchCell class]]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row) {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    self.selectedIndexPath = modelIndexPath;
    
    if(self.deletePickerBlock){
        self.deletePickerBlock();
        self.deletePickerBlock = nil;
    }
    
    switch (modelIndexPath.section) {
        case MAIN_SECTION: // Assignee, Status, Priority, Due Date, Done, Note/Comment + 1 for more/less button
        {
            if([self canOpenPickerForModelIndexPath:modelIndexPath]){
                NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:modelIndexPath.row + 1 inSection:modelIndexPath.section];
                self.pickerIndexPath = pickerIndexPath;
                TRC_OBJ(@"insert");
                [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }else{
                if (modelIndexPath.row == 0) {
                    // Assignee
                    [self showAssigneeSelectionController:indexPath];
                }
                [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
            }
            
        }
            break;
        case SECONDARY_SECTION:
        {
            
            if([self canOpenPickerForModelIndexPath:modelIndexPath]){
                NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:modelIndexPath.row + 1 inSection:modelIndexPath.section];
                self.pickerIndexPath = pickerIndexPath;
                TRC_OBJ(@"insert");
                [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }else{
                if (modelIndexPath.row == 0) {
                    // Project cell
                    [self showProjectSelectionController:indexPath];
                } else if (modelIndexPath.row == 6) {
                    // Milestone cell
                    [self showMilestonesSelectionController:indexPath];
                }
                [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
            }
        }
            break;
        case ATTACHMENTS_SECTION: // Attachments
        {
            if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
                [self addAttachment:indexPath];
            }
        }
            break;
        case CUSTOM_FIELDS_SECTION: // Custom Fields
        {
            NSDictionary *cf = self.issue.customFields[modelIndexPath.row];
            if([listFields containsObject:cf[@"field_format"]]){
                [self showSelectionControllerForCustomField:cf sender:indexPath];
            }
            else if ([dateFields containsObject:cf[@"field_format"]]){
                if([cf[@"field_format"] isEqualToString:@"datetime"]){
                    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
                }else{
                    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:modelIndexPath.row + 1 inSection:modelIndexPath.section];
                    self.pickerIndexPath = pickerIndexPath;
                    [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            }else if ([percentFields containsObject:cf[@"field_format"]]){
                NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:modelIndexPath.row + 1 inSection:modelIndexPath.section];
                self.pickerIndexPath = pickerIndexPath;
                [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
            break;
        default:
            assert(NO);
    }
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    return [pickerIndexPath isEqual:self.pickerIndexPath];
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
            TRC_OBJ(@"delete");
            TRC_OBJ(indexPath);
            self.pickerIndexPath = nil;
            [tableView deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
}


-(void)showProjectSelectionController:(id)sender
{
    NSArray *sortedProjects = self.issue.availableProjects;
    if(sortedProjects.count > 0){
        SingleSectionSelectionTableViewController *vc = [[SingleSectionSelectionTableViewController alloc] initWithItems:sortedProjects multipleSelection:NO searchEnabled:YES];
        vc.selectedItems = self.issue.project ? @[self.issue.project] : nil ;
        [[RACObserve(vc, selectedItems) skip:1] subscribeNext:^(NSArray *x) {
            //		assert(!x.firstObject || [x.firstObject isKindOfClass:[Project class]]);
            self.issue.project = x.firstObject;
            [self validate];
        }];
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

-(void)showSelectionControllerForCustomField:(id)cf sender:(id)sender
{
    NSArray *availableValues = [self.issue.availableCustomFields.rac_sequence filter:^BOOL(id value) {
        return [value[@"id"] isEqual:cf[@"id"]];
    }].array.first[@"values"];
    if(availableValues.count > 0){
        SingleSectionSelectionTableViewController *vc = [[SingleSectionSelectionTableViewController alloc] initWithItems:availableValues multipleSelection:[cf[@"multiple"] boolValue]];
        vc.selectedItems = cf[@"value"] != NSNull.null ? cf[@"value"] : @[];
        @weakify(self)
        [[RACObserve(vc, selectedItems) skip:1] subscribeNext:^(NSArray *x) {
            @strongify(self)
            NSArray *values = [[x rac_sequence] map:^id(id value) {
                return value[@"value"];
            }].array;
            cf[@"value"] = values ?: NSNull.null;
            if([sender isKindOfClass:[NSIndexPath class]]){
                [self.tableView reloadRowsAtIndexPaths:@[sender] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}


- (void)showAssigneeSelectionController:(id)sender
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

- (void)showMilestonesSelectionController:(id)sender
{
    if (self.issue.availableFixedVersions.count) {
        SingleSectionSelectionTableViewController *vc = [[SingleSectionSelectionTableViewController alloc] initWithItems:self.issue.availableFixedVersions multipleSelection:NO searchEnabled:NO];
        vc.selectedItems = self.issue.fixedVersion ? @[self.issue.fixedVersion] : @[];
        [[RACObserve(vc, selectedItems) skip:1] subscribeNext:^(NSArray *x) {
            self.issue.fixedVersion = x.firstObject;
            [self validate];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 3: return NSLocalizedString(@"attachments", @"");
        case 4: if(self.issue.customFields.count > 0) return NSLocalizedString(@"task_detail_custom_fields", @"");
        default: return nil;
    }
}

-(void)addAttachment:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"camera", @"")
                                  , NSLocalizedString(@"gallery", @"")
                                  , nil];
    [actionSheet showInView:self.view];
    @weakify(self)
    RACSignal *actionSheetDelegateSignal = [[[[self rac_signalForSelector:@selector(actionSheet:clickedButtonAtIndex:) fromProtocol:@protocol(UIActionSheetDelegate)]
                                              take:1] map:^id(RACTuple *args) {
        @strongify(self)
        if([args.second unsignedIntegerValue] == 2) {
            self.selectedIndexPath = nil;
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            return nil;
        }
        UIImagePickerController *vc = [UIImagePickerController new];
        vc.sourceType = ([args.second unsignedIntegerValue] == 0) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //		vc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:vc.sourceType]; //CHANGE: dont allow video, theres still some code left over from when we supported videos
        [vc.navigationBar setBarTintColor:kColorMain];
        [vc.navigationBar setTranslucent:NO];
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{ //wait until uialertcontroller has been dismissed on ipad , NOTE: this is not good reactive code, the whole signal should be delayed
            [self presentViewController:vc animated:YES completion:nil];
        });
        
        return vc; //nvm co vratit
    }] ignore:nil];
    
    
    
    __block FileUpload *fileUpload;
    RACSignal *uploadSignal = [actionSheetDelegateSignal flattenMap:^RACStream *(id value) {
        return [[[[[[[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)] take:1] doNext:^(id x) {
            TRC_OBJ(x);
        }] flattenMap:^RACStream *(RACTuple *value) {
            NSDictionary *info = [value second];
            if(info[UIImagePickerControllerMediaURL]){
                return [self createFileUploadFromMediaURL:info[UIImagePickerControllerMediaURL]];
            }else if(info[UIImagePickerControllerOriginalImage]){
                return [self createFileUploadFromImage:info[UIImagePickerControllerOriginalImage]];
            }else{
                assert(NO);
                return [RACSignal error:[NSError errorWithDomain:@"" code:0 userInfo:nil]];
            }
        }] doNext:^(id x) {
            [self.issue.fileUploads addObject:x];
            fileUpload = x;
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self tableView:self.tableView numberOfRowsInSection:ATTACHMENTS_SECTION]-2 inSection:ATTACHMENTS_SECTION]; //before add file cell
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }]
                 flattenMap:^RACStream *(id value) {
                     ++self.pendingUploads;
                     return [[DataService sharedService] uploadAttachment:value];
                 }] replayLazily];
    }];
    
    [[[[[uploadSignal logAll] flattenMap:^id(id value) {
        return value[TokenKey];
    }] deliverOnMainThread] finally:^{
        --self.pendingUploads;
    }]
     subscribeNext:^(id x) {
         fileUpload.token = x;
     } error:^(NSError *error) {
         TRC_OBJ(error)
     } completed:^{
         TRC_ENTRY;
     }]; //TODO:dispose of this signal when cancel is tapped or cell is deleted
}

-(FileUpload *)createFileUpload
{
    FileUpload *newUpload = [FileUpload new];
    newUpload.localIdentifier = @([[self.issue.fileUploads.lastObject localIdentifier] unsignedIntegerValue] + 1);
    return newUpload;
}

-(RACSignal *)createFileUploadFromMediaURL:(NSURL *)mediaUrl
{
    
    return [RACSignal defer:^RACSignal *{
        FileUpload *newUpload = [self createFileUpload];
        //		newUpload.filename = [mediaUrl.lastPathComponent stringByAppendingPathExtension:mediaUrl.pathExtension];
        newUpload.pathExtension = mediaUrl.pathExtension;
        newUpload.contentType = @"video/quicktime";
        newUpload.filename = [NSString stringWithFormat:@"%@.%@", newUpload.localIdentifier, newUpload.pathExtension]; //TODO groot cant serialize computed properties
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtURL:mediaUrl toURL:newUpload.localUrl error:&error];
        if(error){
            return [RACSignal error:error];
        }
        return [RACSignal return:newUpload];
    }];
}

+(NSDateFormatter *)imageDateFormatter
{
    static NSDateFormatter *f;
    if(!f){
        f = [[NSDateFormatter alloc] init];
        f.locale = [NSLocale systemLocale];
        f.dateFormat = @"ddMMyy_HHmm";
    }
    return f;
}

-(RACSignal *)createFileUploadFromImage:(UIImage *)image
{
    //	image = [image resizedImage:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationDefault]; //TODO: remove? rm api limit?
    return [RACSignal defer:^RACSignal *{
        
        FileUpload *newUpload = [self createFileUpload];
        newUpload.pathExtension = @"png";
        newUpload.contentType = @"image/png";
        //		newUpload.filename = [NSString stringWithFormat:@"%@.%@", newUpload.localIdentifier, newUpload.pathExtension]; //TODO groot cant serialize computed properties
        NSDate *now = [NSDate date];
        NSString *dateString = [[[self class] imageDateFormatter] stringFromDate:now];
        newUpload.filename = [NSString stringWithFormat:@"IMG_%@.png", dateString];
        NSData *imageData = UIImagePNGRepresentation(image);
        NSError *error;
        [imageData writeToFile:newUpload.localPath options:0 error:&error];
        if(error){
            return [RACSignal error:error];
        }
        return [RACSignal return:newUpload];
    }];
    return nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)cancelButtonTapped:(id)sender
{
    //	self.issue.fileUploads = [NSSet set]; //TODO cancel any upload tasks
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)validate
{
    [self.validationDisposable dispose]; //dont do multiple validation requests at the same time, they might come back in wrong order
    self.validationDisposable = [[[DataService sharedService] validateIssue:self.issue] subscribeNext:^(id x) {
        if (self.issue.notes.length > 0) {
            NSString *notes = self.issue.notes;
            self.issue = x;
            self.issue.notes = notes;
        } else {
            self.issue = x;
        }
        [self.tableView reloadData]; //reloceladSections messes up contentOffset
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.pickerIndexPath.row -1 inSection:self.pickerIndexPath.section] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
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

-(void)saveButtonTapped:(id)sender
{
    RACSignal *networkRequest = [[DataService sharedService] updateIssue:self.issue];
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.userInteractionEnabled = NO;
    @weakify(self)
    [[networkRequest finally:^{
        @strongify(self)
        self.view.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }]
     subscribeNext:^(id x) {
         ;
     } error:^(NSError *error) {
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
         @strongify(self)
         [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) return -1; //use AutomaticDimension
    
    NSIndexPath *modelIndexPath = indexPath;
    if (self.pickerIndexPath && self.pickerIndexPath.section == indexPath.section && self.pickerIndexPath.row <= indexPath.row)
    {
        modelIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    
    UITableViewCell *cell; //TODO: code only covers necessary states, test on ios7 after every change
    if([indexPath isEqual:self.pickerIndexPath]){
        switch (indexPath.section) {
            case MAIN_SECTION:
            {
                // Picker for due date
                if (indexPath.row == 4) {
                    cell = self.prototypeCells[EditDatePickerCellID];
                } else {
                    cell = self.prototypeCells[EditPickerCellID];
                }
            }
                break;
            case SECONDARY_SECTION:
            {
                // Picker for start date
                if (indexPath.row == 5) {
                    cell = self.prototypeCells[EditDatePickerCellID];
                } else {
                    cell = self.prototypeCells[EditPickerCellID];
                }
            }
                break;
            case CUSTOM_FIELDS_SECTION:
            {
                id cf = self.issue.customFields[modelIndexPath.row];
                if([dateFields containsObject:cf[@"field_format"]]){
                    cell = self.prototypeCells[EditDatePickerCellID];
                }else{
                    cell = self.prototypeCells[EditPickerCellID];
                }
                
            }
            default:
                break;
        }
    }
    
    // 1 for subject and 2 for description
    if(indexPath.section == SECONDARY_SECTION && (indexPath.row == 1 || indexPath.row == 2)){
        EditTextViewCell *textViewCell = self.prototypeCells[EditTextViewCellID];
        textViewCell.textView.text = indexPath.row == 1 ? self.issue.subject : self.issue.issueDescription;
        return [self heightOfTextViewCell:textViewCell];
    }
    
    if (indexPath.section == MAIN_SECTION && indexPath.row == 5) {
        EditTextViewCell *textViewCell = self.prototypeCells[EditTextFieldCellID];
        textViewCell.textView.text = self.issue.notes;
        return [self heightOfTextViewCell:textViewCell];
    }
    
    if(indexPath.section == CUSTOM_FIELDS_SECTION){
        id cf = self.issue.customFields[modelIndexPath.row];
        if([textViewFields containsObject:cf[@"field_format"]]){
            EditTextViewCell *cell = self.prototypeCells[EditTextViewCellID];
            NSString *content = cf[@"value"] == NSNull.null ? @"" : cf[@"value"];
            NSString *prefix = [cf[@"name"] stringByAppendingString:@":\n"];
            cell.textView.text = [prefix stringByAppendingString:content];
            
            return [self heightOfTextViewCell:cell];
        }
    }
    
    if(cell){
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 0.5;
    }
    return 50.;
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ATTACHMENTS_SECTION){
        if(indexPath.row < [tableView numberOfRowsInSection:ATTACHMENTS_SECTION] -1) {
            FileUpload *upload = self.issue.fileUploads[indexPath.row];
            return upload.token != nil; //dont allow deletion during upload
        }
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.issue.fileUploads removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSArray *)doneRatioEntries
{
    int d = 10;
    int items = 100 / d;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:(items+1)]; // +1 because of 100%
    for (int i=0; i<=items; i++) {
        [array addObject:@(i*d)];
    }
    return [array copy];
}

@end
