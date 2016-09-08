//
//  ProjectDetailViewController.m
//  EasyRedmine
//
//  Created by Petr Šíma on Mar/19/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "IssueDetailViewController.h"

#import "IssuesViewController.h"
#import "IssueTableViewCell.h"
#import "FiltersViewController.h"
#import "ProjectDescriptionTableViewCell.h"
#import "ProjectDetailSectionHeaderUIView.h"
#import "ProjectStatisticTableViewCell.h"
#import "NewIssueViewController.h"
#import "OpenUrlHelper.h"

@interface ProjectDetailViewController()<UITableViewDataSource, UITableViewDelegate, IssueDetailViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, readwrite) Project *project;
@property (nonatomic, strong) NSMutableArray *issues;

@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign, getter = isAllDataLoaded) BOOL allDataLoaded;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic, strong) UIRefreshControl *refresh;

@property (nonatomic, strong) NSArray *headrs;
@property (nonatomic, strong) NSArray *statisticsLabel;

@property (nonatomic, weak) UIButton *addIssueButton;
@end

@implementation ProjectDetailViewController

-(instancetype)initWithProject:(Project *)project
{
	if(self = [super init]){
		self.project = project;
	}
	return self;
}


-(void)loadView
{
	UIView *v = [UIView new];
	v.backgroundColor = [UIColor whiteColor];
	v.opaque = YES;
	self.view = v;
	
	UIButton *addUIButton = [UIButton new];
	[self.view addSubview:addUIButton];
	addUIButton.backgroundColor = kColorMain;
	[addUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@54);
		make.width.equalTo(@54);
		make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
		make.right.equalTo(self.view.mas_right).with.offset(-10);
		
	}];
	[addUIButton addTarget:self action:@selector(addIssueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[addUIButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[addUIButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	addUIButton.layer.cornerRadius = 27;
	[addUIButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];

	self.addIssueButton = addUIButton;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.navigationController setTitle:@"Watch by me"];
	self.title = self.project.partialName;
    self.view.backgroundColor = [UIColor blueColor];
    
    //add tableview
    [self setupTableView];
    
  
    UIBarButtonItem *linkBarButton= [UIBarButtonItem barButtonWithImageNamed:@"web_nav" target:self action:@selector(linkBarButtonTouch:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:linkBarButton,nil]];
   
    self.headrs = @[NSLocalizedString(@"description", nil),NSLocalizedString(@"project_detail_statistics", @""),NSLocalizedString(@"project_detail_issues", @"")];
    if ([[[Brand sharedVisual] getCurrentBrand] isEqualToString:kEasyRedmine]) {
        self.statisticsLabel = @[NSLocalizedString(@"new_task_due_date", @""),NSLocalizedString(@"project_detail_sum_time", @""),NSLocalizedString(@"project_detail_estimated_time", @"")];
    }else{
        self.statisticsLabel = @[];
    }
    self.issues = [NSMutableArray array];
    [self loadMoreIssues];
    [self isLoading];
	
	[self.view bringSubviewToFront:self.addIssueButton]; //TODO: remove if we move tableview initialization to -loadView
	[self.addIssueButton addTarget:self action:@selector(addIssueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
}
-(void)linkBarButtonTouch:(UIBarButtonItem*)item
{
    [OpenUrlHelper openProjectDetail:self.project];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[IssueTableViewCell class] forCellReuseIdentifier:[IssueTableViewCell cellIdentifier]];
    [self.tableView registerClass:[ProjectDescriptionTableViewCell class] forCellReuseIdentifier:[ProjectDescriptionTableViewCell cellIdentifier]];
    [self.tableView registerClass:[ProjectStatisticTableViewCell class] forCellReuseIdentifier:[ProjectStatisticTableViewCell cellIdentifier]];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refershHelp) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    activityIndicator.frame = CGRectMake(0, 0, 320, 44);
    self.tableView.tableFooterView = activityIndicator;
    self.activityIndicator = activityIndicator;
    
    
    [RACObserve(self, loading) subscribeNext:^(id x) {
        if([x boolValue]){
            [self.refreshControl beginRefreshing ];
            if (self.issues.count) {
                [self.activityIndicator startAnimating];
            }
        }else{
            [self.refreshControl endRefreshing];
            [self.activityIndicator stopAnimating];
        }
    }];
}

-(void)refershHelp
{
    
    self.issues = [NSMutableArray array];
    self.allDataLoaded = NO;
    [self.tableView isEditing];
    [self loadMoreIssues];
}

-(void)loadMoreIssues
{
    if([self isLoading] || [self isAllDataLoaded]){
        return;
    }
    
    self.loading = YES;
 
    
    
    NSUInteger offset = self.issues.count;
    NSDictionary *filter = @{
                             // kFilterProjectIdKey : @(351),
                             kFilterOffsetKey : @(offset),
                             kFilterLimitKey : @(10),
                             kFilterProjectIdKey : self.project.identifier
                             };
    [[[[DataService sharedService] fetchIssuesWithFilter:filter] finally:^{
        [self.activityIndicator stopAnimating];
        self.loading = NO;
    }]
     subscribeNext:^(NSArray *x) {
         
         
         if(x.count == 0){
             self.allDataLoaded = YES;
             return;
         }
         
         [self.issues addObjectsFromArray:x];
         [self.activityIndicator stopAnimating];
//                  NSMutableArray *newIndexPaths = [NSMutableArray array];
//                  for(NSUInteger i = offset; i < offset + x.count ; i++){
//                      [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:2]];
//                  }
//         [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.tableView reloadData];
         
     } error:^(NSError *error) {
		  self.allDataLoaded = YES;
         TRC_OBJ(error);
     }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL isAtBottom = scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height;
    if(isAtBottom && scrollView.bounds.origin.y > 0){ //dont reload if we're also at the top
        [self loadMoreIssues];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static ProjectDescriptionTableViewCell *prototypeCell;
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
            prototypeCell = [[ProjectDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ProjectDescriptionTableViewCell cellIdentifier]];
        });

        [prototypeCell setModel:self.project.truncatedDescription];
        return [prototypeCell cellHeight];
        
    }else if(indexPath.section == 2){
        return [IssueTableViewCell cellHeight];
    }else{
        return  [ProjectStatisticTableViewCell cellHeight];
    }
    return 0.;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 2){
		return self.issues.count;
    }else if (section == 0){
        if ([self.project.projectDescription length]) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return self.statisticsLabel.count;
    }
	return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProjectDetailSectionHeaderUIView *sectionView = [[ProjectDetailSectionHeaderUIView alloc] init];
    sectionView.textHeaderLabel.text =self.headrs[section];
    return sectionView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [UITableViewCell new] ;
	switch (indexPath.section) {
        case 0 :{
            
            ProjectDescriptionTableViewCell *issueCell = [tableView dequeueReusableCellWithIdentifier:[ProjectDescriptionTableViewCell cellIdentifier] forIndexPath:indexPath];
            [issueCell setModel:self.project.truncatedDescription ];
            cell = issueCell;
        }
            break;
        case 2:
		{
            #warning TODLE JE PRASARNA, ale nevim proc se to deje TODO
            if (self.issues.count) {
                IssueTableViewCell *issueCell = [tableView dequeueReusableCellWithIdentifier:[IssueTableViewCell cellIdentifier] forIndexPath:indexPath];
                Issue *issue = self.issues[indexPath.row];
                [issueCell setModel:issue];
                cell = issueCell;
            }
			break;
		}
        case 1:
        {
            ProjectStatisticTableViewCell *issueCell = [tableView dequeueReusableCellWithIdentifier:[ProjectStatisticTableViewCell cellIdentifier] forIndexPath:indexPath];
            if (indexPath.row == 0 ) {
                if (self.project.easyDueDate) {
                    NSDateFormatter *formatterOut = [[NSDateFormatter alloc] init];
                    [formatterOut setDateFormat:@"dd.MM.yyyy"];
                    [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:[formatterOut  stringFromDate:self.project.easyDueDate]];
                }else{
                   [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:@""];
                }
                
                
            }else if (indexPath.row == 1) {
                
                if (![self.project.sumTimeEntries isEqual:nil]) {
                   
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setMaximumFractionDigits:2];
                    [formatter setMinimumFractionDigits:0];
                    NSString *result = [formatter stringFromNumber:self.project.sumTimeEntries];
                    [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:result];
                }else{
                   [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:@""];
                }
                
            }
            else{
                
                if (![self.project.sumEstimatedHours isEqual:nil]) {
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setMaximumFractionDigits:2];
                    [formatter setMinimumFractionDigits:0];
                    NSString *result = [formatter stringFromNumber:self.project.sumEstimatedHours];
                    [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:result];
                }else{
                    [issueCell setLabel:self.statisticsLabel[indexPath.row] withValue:@""];
                }
            }
            
            cell = issueCell;
        }
			break;
 
        default:
			break;
	}
	//perform global cell configuration
	assert(cell);
	return cell;
}

//TODO: todle bude push v navcontrolleru, zatim presentuju modalne
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
		 
		 UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
												  initWithTitle: @"Back"
												  style: UIBarButtonItemStyleBordered
												  target: nil action: nil];
		 self.navigationItem.backBarButtonItem = backButton;
        IssueDetailViewController *vc = [[IssueDetailViewController alloc] initWithIssue:self.issues[indexPath.row]];
		 vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showIssueDetailViewControllerWithIssue:(id)issue
{
//	IssueDetailViewController *vc = [IssueDetailViewController alloc] initWith
}

-(void)addIssueButtonTapped:(id)sender
{
	[self showAddIssueViewController:sender];
}

-(void)showAddIssueViewController:(id)sender
{
	NewIssueViewController *vc = [[NewIssueViewController alloc] init];
	vc.issue.project = @{@"value" : self.project.identifier, @"name" : self.project.name};
	UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentViewController:navC animated:YES completion:nil]; //TODO: pohadat se s nekym o tom ze to ma byt modalni a ne push jako je to v grafice
}

-(void)issueDetailViewController:(IssueDetailViewController *)vc willDeleteIssue:(Issue *)issue
{
	[self.issues removeObject:issue];
	[self.tableView reloadData];
}
@end
