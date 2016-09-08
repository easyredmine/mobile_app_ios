//
//  TicketsViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 16/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssuesViewController.h"
#import "IssueTableViewCell.h"
#import "FiltersViewController.h"
#import "FilterManager.h"
#import "NewIssueViewController.h"
#import "IssueDetailViewController.h"
#import "JournalsViewController.h"
#import "OpenUrlHelper.h"
#import <AFNetworking/AFURLResponseSerialization.h>
#import "EasyRMAlerts.h"

@interface IssuesViewController () <UITableViewDataSource, UITableViewDelegate, IssueDetailViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *issues;

@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign, getter = isAllDataLoaded) BOOL allDataLoaded;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic, strong) UIRefreshControl *refresh;

@property (nonatomic, weak) RACDisposable *loadDataDisposable;

@end

@implementation IssuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //add tableview
    [self setupTableView];
    [self setupAddButton];
	
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 20;
    
    UIBarButtonItem *filterBarButton =[UIBarButtonItem barButtonWithImageNamed:@"filter_nav" target:self action:@selector(filterBarButtonTouch:)];
    
    UIBarButtonItem *linkBarButton= [UIBarButtonItem barButtonWithImageNamed:@"web_nav" target:self action:@selector(linkBarButtonTouch:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:filterBarButton,space,linkBarButton,nil]];
    self.issues = [NSMutableArray array];
	[self loadMoreIssues:NO];
    [self isLoading];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterChanged:) name:FilterChangedNotificationName object:nil];
	
	
	NSString *title = [[FilterManager sharedService ] getNameOfActualFilter];
	if (title.length) {
		self.title= title;
	}else{
		self.title = NSLocalizedString(@"project_detail_issues", @"");
	}
	//wtf, dont know why this code is here and not filters controller, but it works
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"")
 style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backItem;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}



-(void)setupAddButton
{
    UIButton *addUIButton = [UIButton new];
    [self.view addSubview:addUIButton];
    addUIButton.backgroundColor = kColorMain;
    [addUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@54);
        make.width.equalTo(@54);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        
    }];
    [addUIButton addTarget:self action:@selector(addTicketButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [addUIButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [addUIButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    addUIButton.layer.cornerRadius = 27;
    [addUIButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
}
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
     [self.tableView registerClass:[IssueTableViewCell class] forCellReuseIdentifier:[IssueTableViewCell cellIdentifier]];
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
	
    @weakify(self)
    [RACObserve(self, loading) subscribeNext:^(id x) {
		 @strongify(self)
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
	self.allDataLoaded = NO;
	[self loadMoreIssues:YES];
}

// ------------------------------------------------------------------------
#pragma mark - Table view data source
// ------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IssueTableViewCell cellIdentifier]];
#warning TODLE JE PRASARNA, ale nevim proc se to deje TODO
    if (self.issues.count) {
        [cell setModel:self.issues[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IssueTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   	IssueDetailViewController *vc = [[IssueDetailViewController alloc] initWithIssue:self.issues[indexPath.row]];
	vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)loadMoreIssues:(BOOL)reload
{
    if([self isLoading] || [self isAllDataLoaded]){
        return;
    }
    self.loading = YES;
	NSUInteger offset = reload ? 0 : self.issues.count;
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @(offset),kFilterOffsetKey,
                                @(10),kFilterLimitKey,
                                nil
                             ];
    [filter addEntriesFromDictionary:[[FilterManager sharedService] getUrlParametersActiveFilter]];
	@weakify(self)
	if(self.loadDataDisposable){
		[self.loadDataDisposable dispose]; //just to be safe
	}
	self.loadDataDisposable = [[[[DataService sharedService] fetchIssuesWithFilter:filter] finally:^{
		@strongify(self)
		[self.activityIndicator stopAnimating];
        self.loading = NO;
    }] 
     subscribeNext:^(NSArray *x) {
		  @strongify(self)
		  if(reload){
			  self.issues = [NSMutableArray array];
		  }
         [self.issues addObjectsFromArray:x];
//         NSMutableArray *newIndexPaths = [NSMutableArray array];
//         for(NSUInteger i = offset; i < offset + x.count ; i++){
//             [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//         }
         //[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.tableView reloadData];
         self.allDataLoaded = x.count == 0;
     } error:^(NSError *error) {
		 @strongify(self)
		  TRC_OBJ(error);
         
         self.allDataLoaded = YES;
         
		  NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
		  if(response && response.statusCode == 500){ //this probably means we used a filter that only works with certain projects. Remove the current filter and reloadData
			  [[FilterManager sharedService] restoreFilterToDefault];
			  [self refershHelp];
			  
			  id maybeFiltersVC = self.navigationController.topViewController; //if filterVC is still visible, make it deselect the selected row
			  if([maybeFiltersVC isKindOfClass:[FiltersViewController class]]){
				  [[maybeFiltersVC tableView] reloadData];
			  }
			  			  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FILTERS_INVALID_FILTER_USED_TITLE", @"")
		  message:NSLocalizedString(@"FILTERS_INVALID_FILTER_USED_SUBTITLE", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"")
									  otherButtonTitles:nil] show];
		  }else{
			  [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"errorConnection", @"") block:^{
					 ;
				 }];

		  }
     }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL isAtBottom = scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height;
    if(isAtBottom){
		 [self loadMoreIssues:NO];
    }
}

// ------------------------------------------------------------------------
#pragma mark - Button delegates
// ------------------------------------------------------------------------
#warning TODO filtr link add TICKET
-(void)linkBarButtonTouch:(UIBarButtonItem*)item
{
    TRC_ENTRY;
    TRC_LOG(@"Link bar button TOUCHED");
    [OpenUrlHelper openIssuesWithFilter];
    
}

-(void)filterBarButtonTouch:(UIBarButtonItem*)item
{
    TRC_ENTRY;
    TRC_LOG(@"Filter bar button TOUCHED");
    FiltersViewController *controller = [[FiltersViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)addTicketButtonTouch:(UIButton*)button
{
    TRC_ENTRY;
    TRC_LOG(@"ADD button TOUCHED");
	[self showAddIssueViewController:button];
}

-(void)showAddIssueViewController:(id)sender
{
	NewIssueViewController *vc = [[NewIssueViewController alloc] init];
	UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentViewController:navC animated:YES completion:nil]; //TODO: pohadat se s nekym o tom ze to ma byt modalni a ne push jako je to v grafice
}


-(void)filterChanged:(NSNotification *)notification
{
	NSString *title = [[FilterManager sharedService ] getNameOfActualFilter];
	if (title.length) {
		self.title= title;
	}else{
		self.title = NSLocalizedString(@"project_detail_issues", @"");

	}
	[self refershHelp];
}

-(void)dealloc
{
	if(self.loadDataDisposable) {
		[self.loadDataDisposable dispose];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)issueDetailViewController:(IssueDetailViewController *)vc willDeleteIssue:(Issue *)issue
{
	[self.issues removeObject:issue];
	[self.tableView reloadData];
}
@end
