//
//  IssueDetailUIViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssueDetailViewController.h"
#import "IssueDetailHeaderView.h"
#import "SectionInfoIssue.h"
#import "ProjectDescriptionTableViewCell.h"
#import "IssueSubjectUITableCell.h"
#import "IssueInfoUITableCell.h"
#import "FileUITableViewCell.h"
#import "JournalUITableViewCell.h"
#import "JournalsViewController.h"
#import "EditIssueViewController.h"
#import "ChildrenTableViewCell.h"
#import "IssueAddTimeViewController.h"
#import "OpenUrlHelper.h"
#import "EasyRMAlerts.h"
#import "AttachmentWebViewController.h"
#import <AFNetworking.h>
@interface IssueDetailViewController()<UITableViewDataSource, UITableViewDelegate,SectionHeaderViewDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong, readwrite) Issue *issue;
@property (weak,nonatomic) UIToolbar *toolbar;
@property (strong,nonatomic) NSArray *headrs;
@property (strong,nonatomic) NSArray *journalsArray;
@property (strong,nonatomic) NSArray *relativesArray;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonnull, strong) NSArray *customFieldsArray;
@end
@implementation IssueDetailViewController

// ------------------------------------------------------------------------
#pragma mark - Views setup
// ------------------------------------------------------------------------


-(instancetype)initWithIssue:(Issue *)issue
{
    if(self = [super init]){
        self.issue = issue;
        [self initSection];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Project *project = self.issue.project;
    self.title = project.partialName;
    [self setupToolbar];
    [self setupTableView];
    [self updateSections];
    
    @weakify(self)
    [RACObserve(self.issue , spentHours) subscribeNext:^(Issue *issue) {
        @strongify(self)
        [self updateSections];
        [self.tableView reloadData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDetailIssie];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(refreshTable:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}

-(void)refreshTable:(id)sender
{
    [self updateSections];
    [self.tableView reloadData];
    
}
#warning TAHLE TO NEJDE RESIT JE TO FUUUJ dotaz na PS jak pomoci ReactiveCoco
-(void)loadDetailIssie
{
    [[[[DataService sharedService] fetchDetailOfIssues:self.issue] finally:^{
        
    }]
     subscribeNext:^(Issue *x) {
         self.issue = x;
         
         NSArray *relations = [self.issue.haveRelations allObjects];
         //         for (Relation *relation in relations) {
         //             TRC_OBJ(relation.identifier);
         //             TRC_OBJ(relation.relationType);
         //         }
         [self updateSections];
         [self.tableView reloadData];
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

-(void)initSection
{
    self.sectionInfoArray = [NSMutableArray new];
    
    SectionInfoIssue *sectionTitleTemp = [[SectionInfoIssue alloc] init];
    sectionTitleTemp.open = YES;
    sectionTitleTemp.showHeader = NO;
    sectionTitleTemp.countInSection = 0;
    [self.sectionInfoArray addObject:sectionTitleTemp];
    
    SectionInfoIssue *sectionInfo = [SectionInfoIssue new];
    sectionInfo.open = YES;
    sectionInfo.countInSection = 0;
    sectionInfo.name = NSLocalizedString(@"task_detail_info", @"");
    
    sectionInfo.showHeader = YES;
    [self.sectionInfoArray addObject:sectionInfo];
    
    SectionInfoIssue * descriptionTitle = [SectionInfoIssue new];
    descriptionTitle.open = NO;
    descriptionTitle.showHeader = NO;
    descriptionTitle.countInSection = 0;
    descriptionTitle.name = NSLocalizedString(@"description", @"");
    
    [self.sectionInfoArray addObject:descriptionTitle];
    
    SectionInfoIssue *sectionChildren = [[SectionInfoIssue alloc] init];
    sectionChildren.open = NO;
    sectionChildren.showHeader = NO;
    sectionChildren.name = NSLocalizedString(@"task_detail_children", @"");
    [self.sectionInfoArray addObject:sectionChildren];
    
    SectionInfoIssue *customFields = [SectionInfoIssue new];
    customFields.open = YES;
    customFields.showHeader = NO;
    customFields.name = NSLocalizedString(@"task_detail_custom_fields", @"");
    [self.sectionInfoArray addObject:customFields];
    
    SectionInfoIssue *sectionFiles = [[SectionInfoIssue alloc] init];
    sectionFiles.open = NO;
    sectionFiles.showHeader = NO;
    sectionFiles.name = NSLocalizedString(@"task_detail_attachements", @"");
    [self.sectionInfoArray addObject:sectionFiles];
    
    SectionInfoIssue *sectionRelated = [[SectionInfoIssue alloc] init];
    sectionRelated.open = NO;
    sectionRelated.showHeader = NO;
    sectionRelated.name = NSLocalizedString(@"task_detail_related", @"");
    [self.sectionInfoArray addObject:sectionRelated];
    
    SectionInfoIssue *sectionJournals = [[SectionInfoIssue alloc] init];
    sectionJournals.open = YES;
    sectionJournals.showHeader = NO;
    sectionJournals.name = NSLocalizedString(@"task_detail_journals", @"");
    [self.sectionInfoArray addObject:sectionJournals];
    
    
}

-(void)updateSections
{
    //init secton array
    //    if (self.sectionInfoArray.count < 8) {
    if (self.sectionInfoArray) {
        [self initSection];
    }
    //-------init section title
    SectionInfoIssue *sectionTitleTemp = self.sectionInfoArray [0];
    if ([self.issue.subject length]) {
        sectionTitleTemp.countInSection = 1;
    }else{
        sectionTitleTemp.countInSection = 0;
    }
    sectionTitleTemp.showHeader = NO;
    
    //-------init section info
    SectionInfoIssue *sectionInfo = self.sectionInfoArray [1];
    sectionInfo.countInSection = 13;
    sectionInfo.showHeader = YES;
    
    //-------init section description
    SectionInfoIssue * descriptionTitle = self.sectionInfoArray [2];
    if ([self.issue.issueDescription length]) {
        descriptionTitle.countInSection = 1;
        descriptionTitle.showHeader = YES;
    }else{
        descriptionTitle.countInSection = 0;
        descriptionTitle.showHeader = NO;
    }
    
    //-------init children file
    SectionInfoIssue *sectionChildren = self.sectionInfoArray [3];
    
    if ([self.issue.children count]) {
        sectionChildren.showHeader = YES;
    }else{
        sectionChildren.showHeader = NO;
    }
    sectionChildren.countInSection = (int)[self.issue.children count];
    
    
    //-------init section related
    SectionInfoIssue *sectionRelated = self.sectionInfoArray [6];
    self.relativesArray = self.issue.allRelatives;
    if ([self.relativesArray count]) {
        sectionRelated.showHeader = YES;
    }else{
        sectionRelated.showHeader = NO;
    }
    sectionRelated.countInSection = (int)[self.relativesArray count];
    
    //-------init section file
    SectionInfoIssue *sectionFiles = self.sectionInfoArray [5];
    if ([self.issue.attachments count]) {
        sectionFiles.showHeader = YES;
    }else{
        sectionFiles.showHeader = NO;
    }
    sectionFiles.countInSection = (int)[[self.issue.attachments allObjects]count];
    
    //-------init customFields
    SectionInfoIssue *customFields = self.sectionInfoArray [4];
    self.customFieldsArray = self.issue.sortedCustomFields;
    if ([self.customFieldsArray count]) {
        customFields.showHeader = YES;
    }else{
        customFields.showHeader = NO;
    }
    customFields.countInSection = (int)[self.customFieldsArray count];
    
    //-------init section journals
    SectionInfoIssue *sectionJournals = self.sectionInfoArray [7];
    self.journalsArray = self.issue.sortedJournalsWithNotes;
    if ([self.journalsArray count]) {
        sectionJournals.showHeader = YES;
    }else{
        sectionJournals.showHeader = NO;
        
    }
    sectionJournals.countInSection = (int)[self.journalsArray count];
}

-(void) setupTableView
{
    //made tv weak to ensure there are no more memory leaks (although they werent caused by the strong reference to tableView)
    UITableView *tableView = [[UITableView alloc] init];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.toolbar.mas_top);
    }];
    
    tableView.allowsSelection = YES;
    self.tableView = tableView;
    [self registerTableCells];
}
-(void)registerTableCells
{
    [self.tableView registerClass:[ProjectDescriptionTableViewCell class] forCellReuseIdentifier:[ProjectDescriptionTableViewCell cellIdentifier]];
    [self.tableView registerClass:[IssueSubjectUITableCell class] forCellReuseIdentifier:[IssueSubjectUITableCell cellIdentifier]];
    [self.tableView registerClass:[IssueInfoUITableCell class] forCellReuseIdentifier:[IssueInfoUITableCell cellIdentifier]];
    [self.tableView registerClass:[IssueDetailHeaderView class]forHeaderFooterViewReuseIdentifier:[IssueDetailHeaderView headerIdentifier]];
    [self.tableView registerClass:[FileUITableViewCell class]forCellReuseIdentifier:[FileUITableViewCell cellIdentifier]];
    [self.tableView registerClass:[JournalUITableViewCell class]forCellReuseIdentifier:[JournalUITableViewCell cellIdentifier]];
    [self.tableView registerClass:[ChildrenTableViewCell class]forCellReuseIdentifier:[ChildrenTableViewCell cellIdentifier]];
}

-(void) setupToolbar
{
    
    UIToolbar *toolbar = [UIToolbar new];
    [self.view addSubview:toolbar];
    toolbar.backgroundColor = kGrayColor;
    toolbar.tintColor = kColorMain;
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    self.toolbar = toolbar;
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editBarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonTapped:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *addtimeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_addtime"] style:UIBarButtonItemStylePlain target:self action:@selector(addTimeButtonTapped:)];
//    
//    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_comment"] style:UIBarButtonItemStylePlain target:self action:@selector(commentButtonTapped:)];
    
    UIBarButtonItem *webItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_web"] style:UIBarButtonItemStylePlain target:self action:@selector(webButtonTapped:)];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(trashButtonTapped:)];
    
//    toolbar.items = @[editItem,flexibleSpace,addtimeItem,flexibleSpace,commentItem,flexibleSpace,webItem,flexibleSpace,deleteItem];
    toolbar.items = @[editItem,flexibleSpace,addtimeItem,flexibleSpace,webItem,flexibleSpace,deleteItem];
}
// ------------------------------------------------------------------------
#pragma mark - Toolbar selectors
// ------------------------------------------------------------------------
-(void)editButtonTapped:(id)sender
{
    [self showEditIssueViewController:sender];
}

-(void)addTimeButtonTapped:(id)sender
{
    [self showIssueAddTimeViewController:sender];
}

-(void)commentButtonTapped:(id)sender
{
    [self showJournalsViewController:sender];
}

-(void)webButtonTapped:(id)sender
{
    TRC_ENTRY;
    TRC_LOG(@"OPEN URL IN ISSUE DETAIL");
    [OpenUrlHelper openIssueDetail:self.issue];
}

-(void)trashButtonTapped:(id)sender
{
    TRC_ENTRY;
    TRC_LOG(@"DELETE ISSUE");
    
    [EasyRMAlerts showDialogWithTitle:NSLocalizedString(@"add_time_warning_title", @"")
                       andDescription:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"dialog_title_delete_task", @"")
                                       ,self.issue.name] block:^{
                           
                           [[[DataService sharedService] deleteIssue:self.issue]
                            subscribeError:^(NSError *error) {
                                TRC_OBJ(error);
                            } completed:^{
                                if([self.delegate respondsToSelector:@selector(issueDetailViewController:willDeleteIssue:)]){
                                    [self.delegate issueDetailViewController:self willDeleteIssue:self.issue];
                                }
                                [self.issue MR_deleteEntity];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                           
                       }];
    
}
// ------------------------------------------------------------------------
#pragma mark - Table view data source
// ------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 ){
        static IssueSubjectUITableCell *prototypeCell;
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
            prototypeCell = [[IssueSubjectUITableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IssueSubjectUITableCell cellIdentifier]];
        });
        [prototypeCell setModel:self.issue.subject];
        return [prototypeCell cellHeight];
    } else if (indexPath.section == 1) {
        
        static IssueInfoUITableCell *prototypeCell;
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            prototypeCell = [[IssueInfoUITableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IssueInfoUITableCell cellIdentifier]];
        });
        [prototypeCell  setModel:[self getInfoDictionaryForRow:indexPath.row]];
        CGFloat height = [prototypeCell cellHeight];
        [prototypeCell prepareForReuse];
        return height;
    } else if (indexPath.section == 2) {
        
        static ProjectDescriptionTableViewCell *prototypeCell;
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
            prototypeCell = [[ProjectDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ProjectDescriptionTableViewCell cellIdentifier]];
        });
        [prototypeCell setModel:self.issue.truncatedDescription];
        return [prototypeCell cellHeight];
        
        
    } else if(indexPath.section == 7 ) {
        static JournalUITableViewCell *prototypeCell;
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
            prototypeCell = [[JournalUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[JournalUITableViewCell cellIdentifier]];
        });
        
        Journal *journal = self.journalsArray[indexPath.row];
        [prototypeCell setModel:journal];
        return [prototypeCell cellHeight];
    } else if(indexPath.section == 6) {
        static IssueInfoUITableCell *prototypeCell;
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            prototypeCell = [[IssueInfoUITableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IssueInfoUITableCell cellIdentifier]];
        });
        [self configureCustomFieldsCell:prototypeCell forIndexPath:indexPath];
        CGFloat height = [prototypeCell cellHeight];
        [prototypeCell prepareForReuse];
        return height;
        
    }
    
    return 44.;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionInfoArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfoIssue *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = sectionInfo.countInSection;
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    SectionInfoIssue *sectionInfo = (self.sectionInfoArray)[section];
    if (!sectionInfo.showHeader) {
        return 0;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IssueDetailHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[IssueDetailHeaderView headerIdentifier]];
    SectionInfoIssue *sectionInfo = (self.sectionInfoArray)[section];
    if (!sectionInfo.showHeader) {
        return nil;
    }
    sectionHeaderView.opened = sectionInfo.open;
    [sectionHeaderView setActualStateOfArrow];
    sectionHeaderView.titleLabel.text = sectionInfo.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    return sectionHeaderView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    
    {
        case 0:{
            IssueSubjectUITableCell *issueCell = [self.tableView dequeueReusableCellWithIdentifier:[IssueSubjectUITableCell cellIdentifier] forIndexPath:indexPath];
            [issueCell setModel:self.issue.subject ];
            cell = issueCell;
        }
            break;
            
        case 1:{
            IssueInfoUITableCell *infoCell = [self.tableView dequeueReusableCellWithIdentifier:[IssueInfoUITableCell cellIdentifier] forIndexPath:indexPath];
            [infoCell  setModel:[self getInfoDictionaryForRow:indexPath.row]];
            cell = infoCell;
        }
            break;
            
        case 2:{
            ProjectDescriptionTableViewCell *projectCell = [self.tableView dequeueReusableCellWithIdentifier:[ProjectDescriptionTableViewCell cellIdentifier] forIndexPath:indexPath];
            [projectCell setModel:self.issue.truncatedDescription];
            cell = projectCell;
        }
            break;
            
        case 3:{
            ChildrenTableViewCell *childrenCell = [self.tableView dequeueReusableCellWithIdentifier:[ChildrenTableViewCell cellIdentifier] forIndexPath:indexPath];
            NSArray *children = [self.issue.children allObjects];
            [childrenCell  setModel:children[indexPath.row]];
            cell = childrenCell;
        }
            break;
            
        case 6:{
            //TODO sere se to pri refresh
            ChildrenTableViewCell *realtiveCell = [self.tableView dequeueReusableCellWithIdentifier:[ChildrenTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            Relation *relation = self.relativesArray[indexPath.row];
            
            Issue *issue = relation.issueTo;
            
            if ([issue.identifier isEqual:self.issue.identifier]) {
                issue = relation.issue;
            }
            
            [realtiveCell  setModel:issue];
            cell = realtiveCell;
        }
            break;
            
        case 5:{
            FileUITableViewCell *fileCell = [self.tableView dequeueReusableCellWithIdentifier:[FileUITableViewCell cellIdentifier] forIndexPath:indexPath];
            NSArray *files = self.issue.sortedAttachments;
            [fileCell  setModel:files[indexPath.row]];
            cell = fileCell;
        }
            break;
            
        case 4:
        {
            IssueInfoUITableCell *cfCell = [tableView dequeueReusableCellWithIdentifier:[IssueInfoUITableCell cellIdentifier] forIndexPath:indexPath];
            [self configureCustomFieldsCell:cfCell forIndexPath:indexPath];
            cell = cfCell;
        }
            if(cell) break;
            
        case 7:{
            JournalUITableViewCell *journalCell = [self.tableView dequeueReusableCellWithIdentifier:[JournalUITableViewCell cellIdentifier] forIndexPath:indexPath];
            Journal *journal = self.journalsArray[indexPath.row];
            [journalCell  setModel:journal];
            cell = journalCell;
        }
            break;
            
        default:
            
            cell = [UITableViewCell new];
            cell.backgroundColor = [ UIColor yellowColor];
            break;
            
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)configureCustomFieldsCell:(IssueInfoUITableCell *)cfCell forIndexPath:(NSIndexPath *)indexPath
{
    CustomField *cf = self.customFieldsArray[indexPath.row];
    id detailText;
    if([cf isKindOfClass:[CFBool class]]){
        CFBool *cfBool = (id)cf;
        if([cfBool.value boolValue]){
            detailText = NSLocalizedString(@"yes", @"");
        }else if(cfBool.value){ //if value == nil, do nothing here
            detailText = NSLocalizedString(@"no", @"");
        }
    }
    else if([cf isKindOfClass:[CFString class]]){
        CFString *cfString = (id)cf;
        detailText = cfString.value;
        if([cfString isKindOfClass:[CFHTML class]]){
            NSAttributedString *attrString = [self attributedStringFromHtmlString:detailText];
            if(attrString) detailText = attrString;
        }
    }
    else if([cf isKindOfClass:[CFFloat class]]){
        CFFloat *cfFloat = (id)cf;
        detailText = cfFloat.value.stringValue;
    }else if([cf isKindOfClass:[CFInt class]]){
        CFInt *cfInt = (id)cf;
        detailText = cfInt.value.stringValue;
        if([cf isKindOfClass:[CFPercent class]]){
            detailText = [detailText stringByAppendingString:NSLocalizedString(@"%", @"")];
        }
    }else if([cf isKindOfClass:[CFList class]]){
        CFList *cfList = (id)cf;
        RACSequence *values = [cfList.value rac_sequence];
        detailText = [[values tail] foldLeftWithStart:[values head] reduce:^id(id accumulator, id value) {
            return [NSString stringWithFormat:@"%@, %@", accumulator, value];
        }];
        if([detailText isEqualToString:@""]){
            detailText = nil;
        }
    }else if([cf isKindOfClass:[CFDate class]]){
        CFDate *cfDate = (id)cf;
        //		detailText = cfDate.value.description;
        if([cfDate.fieldFormat isEqualToString:@"date"]){ //TODO: make a separate entity?
            detailText = [NSDateFormatter localizedStringFromDate:cfDate.value dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        }else{
            detailText = [NSDateFormatter localizedStringFromDate:cfDate.value dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        }
        
    }
    
    if(!detailText) detailText = NSLocalizedString(@"none", @"");
    
    [cfCell setModel:@{kIssueInfoUITableCellDescriptionKey : cf.name, kIssueInfoUITableCellLabelKey : detailText}];
}

-(NSAttributedString *)attributedStringFromHtmlString:(NSString *)string
{
    return nil; // this causes performance problems
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        File *file =self.issue.sortedAttachments[indexPath.row];
        NSURL *url = [NSURL URLWithString:file.contentUrl];
        AttachmentWebViewController *vc = [AttachmentWebViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [vc.webView loadRequest:[[DataService sharedService] requestWithMethod:@"GET" url:url]];
    }
    else if (indexPath.section == 3){
        NSArray *children = [self.issue.children allObjects];
        
        IssueDetailViewController *vc = [[IssueDetailViewController alloc] initWithIssue:children[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 6){
        Relation *relation = self.relativesArray[indexPath.row];
        
        Issue *issue = relation.issueTo;
        
        if ([issue.identifier isEqual:self.issue.identifier]) {
            issue = relation.issue;
        }
        IssueDetailViewController *vc = [[IssueDetailViewController alloc] initWithIssue:issue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
// ------------------------------------------------------------------------
#pragma mark - Section delegate
// ------------------------------------------------------------------------
- (void)sectionHeaderView:(IssueDetailHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section
{
    TRC_LOG(@"SECTION TO OPEN");
    SectionInfoIssue *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.open = YES;
    NSInteger countOfRowsToInsert = sectionInfo.countInSection;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)sectionHeaderView:(IssueDetailHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    TRC_LOG(@"SECTION TO CLOSE");
    SectionInfoIssue *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
    }
    
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
}
// ------------------------------------------------------------------------
#pragma mark - Controller helpers
// ------------------------------------------------------------------------
-(NSDictionary *)getInfoDictionaryForRow:(NSInteger)row
{
    NSMutableDictionary *tempDictionary = [NSMutableDictionary new];
    switch (row)
    {
        case 0:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_assignee", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            if (self.issue.assignedTo.name.length ) {
                [tempDictionary setObject:self.issue.assignedTo.name forKey:kIssueInfoUITableCellLabelKey];
            }else{
                [tempDictionary setObject:@"- -" forKey:kIssueInfoUITableCellLabelKey];
            }
            
        }
            break;
            
        case 1:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_due_date", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            
            NSDateFormatter *formatterOut = [[NSDateFormatter alloc] init];
            [formatterOut setDateFormat:@"dd.MM.yyyy"];
            if (self.issue.dueDate) {
                [tempDictionary setObject:[formatterOut  stringFromDate:self.issue.dueDate] forKey:kIssueInfoUITableCellLabelKey];
            }else{
                [tempDictionary setObject:@"- -" forKey:kIssueInfoUITableCellLabelKey];
            }
        }
            break;
            
        case 2:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_priority", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:self.issue.priority.name forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 3:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_tracker", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:self.issue.tracker.name forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 4:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_status", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:[NSString stringWithFormat:@"%@ (%d%%)",self.issue.status.name,(int)self.issue.doneRatioValue] forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 5:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_author", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:self.issue.author.name forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 6:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_start_time", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            
            [tempDictionary setObject:[[[self class] dateFormatter] stringFromDate:self.issue.startDate] forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 7:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_milestone", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            if (self.issue.fixedVersion.name.length ) {
                [tempDictionary setObject:self.issue.fixedVersion.name forKey:kIssueInfoUITableCellLabelKey];
            }else{
                [tempDictionary setObject:@"- -" forKey:kIssueInfoUITableCellLabelKey];
            }
            
        }
            break;
  
        case 8:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_estimated_time", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            if (!self.issue.estimatedHoursValue) {
                [tempDictionary setObject:NSLocalizedString(@"new_task_none", @"")
                                   forKey:@"label"];
            }else{
                [tempDictionary setObject:[[[self class] numberFormatter] stringFromNumber:self.issue.estimatedHours] forKey:kIssueInfoUITableCellLabelKey];
            }
        }
            break;
            
        case 9:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_spent_time", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:[[[self class] numberFormatter] stringFromNumber:self.issue.spentHours] forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
        case 10:
        {
                [tempDictionary setObject:NSLocalizedString(@"task_detail_category", @"")
                                   forKey:kIssueInfoUITableCellDescriptionKey];
            NSString *categoryName = [self.issue.category name];
            [tempDictionary setObject:categoryName.length > 0 ? categoryName : @"- -" forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 11:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_id", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:[self.issue.identifier stringValue] forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            
        case 12:
        {
            [tempDictionary setObject:NSLocalizedString(@"task_detail_project", @"")
                               forKey:kIssueInfoUITableCellDescriptionKey];
            [tempDictionary setObject:self.issue.project.name forKey:kIssueInfoUITableCellLabelKey];
        }
            break;
            

            
        default:
            break;
    }
    return tempDictionary;
}

// ------------------------------------------------------------------------
#pragma mark -
// ------------------------------------------------------------------------
+(NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *f;
    if(!f){
        f = [NSNumberFormatter new];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        f.roundingMode = NSNumberFormatterRoundHalfUp;
        f.minimumFractionDigits = 2;
        f.maximumFractionDigits = 2;
    }
    return f;
}
             
+(NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *f;
    if(!f){
        f = [NSDateFormatter new];
        [f setDateFormat:@"dd.MM.YYYY"];
    }
    return f;
}

// ------------------------------------------------------------------------
#pragma mark -
// ------------------------------------------------------------------------
-(void)showEditIssueViewController:(id)sender
{
    //pass an issue in a new context
    NSManagedObjectContext *tempContext = [NSManagedObjectContext MR_contextWithParent:self.issue.managedObjectContext];
    Issue *issue = [Issue MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", self.issue.identifier] inContext:tempContext];
    EditIssueViewController *vc = [[EditIssueViewController alloc] initWithIssue:issue];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navC animated:YES completion:nil]; //TODO: pohadat se s nekym o tom ze to ma byt modalni a ne push jako je to v grafice
}

-(void)showJournalsViewController:(id)sender
{
    JournalsViewController *vc = [[JournalsViewController alloc] initWithJournals:self.issue andTitle:self.issue.name];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showIssueAddTimeViewController:(id)sender
{
    IssueAddTimeViewController *vc = [[IssueAddTimeViewController alloc] initWithIssue:self.issue];
    //UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    //[self presentViewController:navC animated:YES completion:nil]; //TODO: pohadat se s nekym o tom ze to ma byt modalni a ne push jako je to v grafice
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
