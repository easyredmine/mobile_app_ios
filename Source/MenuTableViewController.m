//
//  MenuTableViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 12/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "MenuTableViewController.h"
#import "AppDelegate.h"
#import "ResultSearchTableViewCell.h"
#import "LoginViewController.h"
#import "IssuesViewController.h"
#import "ProjectDetailViewController.h"
#import "MenuUIView.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"
#import "NSManagedObjectContext+MRResetContext.h"
#import "FilterManager.h"

@interface MenuTableViewController ()< UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MenuUIView *menuView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *issueUIButton;
@property (nonatomic,strong) UIView *textFiledView;
@property (nonatomic,strong)  UITextField *searchUITextField;
@property (nonatomic,strong) UILabel *emailUILabel;
@property (nonatomic) BOOL searchIsActive;
@property (nonatomic,strong) NSArray *searchResults;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UIButton *cancelUIButton;
@property (nonatomic,strong) UIButton *createNewIssueButton;
@property (nonatomic,strong) UIButton *logoutUIButton;
@end


@implementation MenuTableViewController

// ------------------------------------------------------------------------
#pragma mark - Controller stuff
// ------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorMain;
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.searchResults = nil;

    MenuUIView *menuView = [MenuUIView new];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right).with.offset(-appdelegate.slidingViewController.anchorRightPeekAmount);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.menuView = menuView;
    self.issueUIButton = menuView.issueUIButton;
    self.textFiledView = menuView.textFiledView;
    self.searchUITextField = menuView.searchUITextField;
    self.logoImageView = menuView.logoImageView;
    self.cancelUIButton = menuView.cancelButton;
    self.createNewIssueButton = menuView.createNewIssueButton;
    self.logoutUIButton = menuView.logoutUIButton;
    self.emailUILabel = menuView.emailUILabel;
    [self.searchUITextField setDelegate:self];
	self.searchUITextField.returnKeyType = UIReturnKeyDone;
    [self.cancelUIButton addTarget:self
                           action:@selector(cancelButtonTap:)
                 forControlEvents:UIControlEventTouchUpInside];
  
    [self.createNewIssueButton addTarget:self
                           action:@selector(newIssueTouchButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.issueUIButton addTarget:self
                           action:@selector(issuesTouchButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.logoutUIButton addTarget:self
                       action:@selector(logoutTouchButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setupTableView];
    
    [self.searchUITextField.rac_textSignal subscribeNext:^(id x) {
        self.searchResults = [self loadDataWithSearch:x];
        [self.tableView reloadData];
        [self bannerForEmptyTableView];
    }];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//    [self hideSearchResultsTable];
    [self hideSearchResultsTable];
    [self.searchUITextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat deltaHeight = kbSize.height;
    
    [self showSearchResultsTableWithOffsetFromBottom:deltaHeight];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [self showSearchResultsTableWithOffsetFromBottom:0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	self.tableView.tableHeaderView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kColorMain;
    self.textFiledView.backgroundColor = kColorMainDark;
    self.tableView.backgroundColor = kColorMainDark;
    [self.logoImageView setImage:[RedmineUI imageNamed:@"logo_white"]];
    [self.emailUILabel setText:[self getUsername]];
    self.menuView.delimiteDownView.backgroundColor = kColorMainDark;
    self.menuView.delimiterUpView.backgroundColor = kColorMainDark;
    self.searchUITextField.text = NSLocalizedString(@"searchProject", @"");
    [self.searchUITextField resignFirstResponder];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate anchorRight];
}
// ------------------------------------------------------------------------
#pragma mark - Buttons dele
// ------------------------------------------------------------------------
#warning TODO
-(void)newIssueTouchButton:(UIButton*)button
{
    TRC_ENTRY;
	ECSlidingViewController *hamburgerMenuVC = (id)self.parentViewController;
	UINavigationController *navC = (id)[hamburgerMenuVC topViewController];
	[navC popToRootViewControllerAnimated:NO];
	id homeVC = [navC topViewController];
	assert([homeVC isKindOfClass:[IssuesViewController class]]);
	[hamburgerMenuVC resetTopViewAnimated:YES onComplete:^{
		[homeVC showAddIssueViewController:self];
	}];


	
    TRC_LOG(@"NewIssue  button TOUCHED");
}

-(void)issuesTouchButton:(UIButton*)button
{
    TRC_ENTRY;
    TRC_LOG(@"Issue button TOUCHED");
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *topViewController = (UINavigationController *)appdelegate.slidingViewController.topViewController;
    [self switchViewControllerTo:[IssuesViewController class] navigationController:topViewController];
    
    [appdelegate.slidingViewController resetTopViewAnimated:YES];
    
}

-(void)logoutTouchButton:(UIButton*)button
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *topViewController = (UINavigationController *)appdelegate.slidingViewController.topViewController;
    [self switchViewControllerTo:[LoginViewController class] navigationController:topViewController];
    
    [appdelegate.slidingViewController resetTopViewAnimated:YES];

    [UserDefaults setBool:NO forKey:kIsLogged];
    [UserDefaults synchronize];

	[[DataService sharedService] reset];
	
	//this magic ensures that removePersistenStore:error: doesnt deadlock
	[[NSManagedObjectContext MR_defaultContext] performBlockAndWait:^{
		[[NSManagedObjectContext MR_defaultContext] reset];
	}];
	[[NSManagedObjectContext MR_rootSavingContext] performBlockAndWait:^{
		[[NSManagedObjectContext MR_rootSavingContext] reset];
	}];
	//#endmagic
	
	NSPersistentStoreCoordinator *storeCoordinator = [[NSManagedObjectContext MR_defaultContext] persistentStoreCoordinator];
	NSPersistentStore *store = [[storeCoordinator persistentStores] firstObject];
	NSError *error;
	NSURL *storeURL = store.URL;
	[storeCoordinator removePersistentStore:store error:&error];
	[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:nil];
		[MagicalRecord setupAutoMigratingCoreDataStack];
	//!!!This duplicates private MR behaviour, might break if we update MR

	NSManagedObjectContext *rootContext = [NSManagedObjectContext MR_contextWithStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
	[NSManagedObjectContext MR_setRootSavingContext:rootContext];
	
	NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_newMainQueueContext];
	[NSManagedObjectContext MR_setDefaultContext:defaultContext];
	
	[defaultContext setParentContext:rootContext];
	
	[[FilterManager sharedService] restoreFilterToDefault];
	
    TRC_LOG(@"LOGOUT");
    
}
// ------------------------------------------------------------------------
#pragma mark - Search
// ------------------------------------------------------------------------
- (NSArray *)loadDataWithSearch:(NSString *)searchString
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                ascending:YES];
    NSArray *projects = [Project MR_findAll];
    if (searchString.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
        projects = [[projects filteredArrayUsingPredicate:predicate]
                    sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    }else{
        projects = [projects
                    sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    return  projects;
}

-(void)cancelButtonTap:(UIButton *)item {
    [self.searchUITextField resignFirstResponder];
    [self hideSearchResultsTable];
    self.searchUITextField.text = NSLocalizedString(@"searchProject", nil);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (![self.searchUITextField isFirstResponder])
//        [self.searchUITextField becomeFirstResponder];
  //[self.searchUITextField becomeFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
    textField.text = @"";
    self.searchResults = [self loadDataWithSearch:@""];
    [self.tableView reloadData];

    [self bannerForEmptyTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kColorMainDark;    
    [self.tableView registerClass:[ResultSearchTableViewCell class] forCellReuseIdentifier:[ResultSearchTableViewCell cellIdentifier]];
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self hideSearchResultsTable];
}
// ------------------------------------------------------------------------
#pragma mark - Table view data source
// ------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResultSearchTableViewCell cellIdentifier]];
    Project *project = self.searchResults[indexPath.row];
    [cell setModel:project];
    return cell;
}

static ResultSearchTableViewCell *prototypeCell = nil;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) 	return -1; //use AutomaticDimension
	if(!prototypeCell){
		prototypeCell = [[ResultSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
	}
	[prototypeCell setModel:self.searchResults[indexPath.row]];
	prototypeCell.textUILabel.preferredMaxLayoutWidth = tableView.bounds.size.width -50;
	prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(prototypeCell.bounds));
	[prototypeCell setNeedsLayout];
	[prototypeCell layoutIfNeeded];
	CGSize size = [prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	return size.height + 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project *project = self.searchResults[indexPath.row];
    [self.searchUITextField resignFirstResponder];
    [self hideSearchResultsTable];
    self.searchUITextField.text = project.name;
	
    TRC_LOG(@"Selected project id:%@, full name: %@,name: %@",project.identifier ,project.name,project.partialName);
   
    ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithProject:project];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *topViewController = (UINavigationController *)appdelegate.slidingViewController.topViewController;

    
    [topViewController popToRootViewControllerAnimated:NO];
    [topViewController pushViewController:vc animated:NO];
    
    [appdelegate.slidingViewController resetTopViewAnimated:YES];
}

-(void)showProjectDetailViewControllerWithProject:(Project *)project
{
	ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithProject:project];
	[self presentViewController:vc animated:YES completion:nil];
}

-(void)showSearchResultsTableWithOffsetFromBottom:(int)offset
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiledView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).with.offset(-appdelegate.slidingViewController.anchorRightPeekAmount);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-offset);
    }];
    if (!self.searchIsActive) {
        self.searchIsActive = true;
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }
    
     DEFINE_BLOCK_SELF;
    [UIView animateWithDuration:0.5 animations:^{[blockSelf.tableView layoutIfNeeded];}];
    
}

-(void)hideSearchResultsTable
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiledView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).with.offset(-appdelegate.slidingViewController.anchorRightPeekAmount);
        make.bottom.equalTo(self.textFiledView.mas_bottom);
    }];
     DEFINE_BLOCK_SELF;
    [UIView animateWithDuration:0.5 animations:^{[blockSelf.tableView layoutIfNeeded];}];
    self.searchIsActive = false;
}
// ------------------------------------------------------------------------
#pragma mark - Controller helper
// ------------------------------------------------------------------------
-(NSString *)getUsername
{
    NSArray *people = [UserCredentials MR_findAll];
    UserCredentials *creditals = people.lastObject;
    return creditals.username;
}

-(void) bannerForEmptyTableView
{
    if([self.searchResults count] == 0) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 99999, 30)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"search_no_result", @"").uppercaseString;
		 @weakify(self)
		 dispatch_async(dispatch_get_main_queue(), ^{ //setting tableheaderview synchronously prevents keyboard from showing
			 @strongify(self)
			 TRC_ENTRY;
			 self.tableView.tableHeaderView = label;
		 });

    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
		 @weakify(self)
		 dispatch_async(dispatch_get_main_queue(), ^{ //setting tableheaderview synchronously prevents keyboard from showing
			 @strongify(self)
			 TRC_ENTRY;
			 self.tableView.tableHeaderView = nil;
		 });

    }
}
- (void)switchViewControllerTo:(Class)controller navigationController:(UINavigationController *)navigationController
{
    if ([navigationController.topViewController class] == controller) {
        return;
    }
    
	navigationController.viewControllers = @[[[controller alloc] init]];
	//    [navigationController popToRootViewControllerAnimated:NO];
//    [navigationController pushViewController:[[controller alloc] init] animated:NO]; //dont leave rootViewController on navigationStack
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    BOOL isAtBottom = scrollView.contentOffset.y  >= 50;
//    if (isAtBottom){
//       [self.searchUITextField resignFirstResponder];
//    }
}
@end
