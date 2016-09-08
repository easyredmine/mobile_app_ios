//
//  JournalsViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 04/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "JournalsViewController.h"
#import "JournalUITableViewCell.h"
#import "ComposerView.h"
#import "AddJournalViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


@interface JournalsViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (readonly, nonatomic) UIView *container;
@property (strong, nonatomic) Issue *issue;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *journals;
@property (strong,nonatomic) NSString *navTitle;

@end


@implementation JournalsViewController
- (instancetype)initWithJournals:(Issue*)issue andTitle:(NSString*) title
{
    self = [super init];
    
    if (self) {
        self.issue = issue;
        self.journals = issue.sortedJournalsWithNotes;
        self.navTitle = title;
    }
    return self;
}

-(void)keyboardWillShow
{
    [self moveTableViewToTopOrBottom];
}

-(void)keyboardWillHide
{
    [self moveTableViewToTopOrBottom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.topViewController.title = self.navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [RACObserve(self, keyboardLayoutGuide) subscribeNext:^(id tmp) {
        [self moveTableViewToTopOrBottom];
    }];
    
    
    [self setupTableView];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
    
    UIBarButtonItem *addJournalButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addJournal)];
    self.navigationItem.rightBarButtonItem = addJournalButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void) setupTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[JournalUITableViewCell class]forCellReuseIdentifier:[JournalUITableViewCell cellIdentifier]];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self moveTableViewToTopOrBottom];
}

- (void)addJournal
{
    AddJournalViewController *addJournalController = [[AddJournalViewController alloc] initWithIssue:self.issue];
    DEFINE_BLOCK_SELF;
    addJournalController.finishingBlock = ^(Issue *issue){
        blockSelf.issue = issue;
        blockSelf.journals = issue.sortedJournalsWithNotes;
        [blockSelf.tableView reloadData];
    };
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:addJournalController];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


-(void)moveTableViewToTopOrBottom
{
    if (![UserDefaults boolForKey:kJournalOrderAsc]) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }else{
        if (self.journals.count > 0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.journals.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static JournalUITableViewCell *prototypeCell;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        prototypeCell = [[JournalUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[JournalUITableViewCell cellIdentifier]];
    });
    
    Journal *journal = self.journals[indexPath.row];
    [prototypeCell setModel:journal];
    return [prototypeCell cellHeight];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.journals.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JournalUITableViewCell *issueCell = [tableView dequeueReusableCellWithIdentifier:[JournalUITableViewCell cellIdentifier] forIndexPath:indexPath];
    
    [issueCell setModel:self.journals[indexPath.row] ];
    [issueCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return issueCell;
}

-(void)dealloc
{
	self.tableView.emptyDataSetSource = nil;
	self.tableView.emptyDataSetDelegate = nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
	NSString *text = NSLocalizedString(@"JOURNALS_EMPTY_DATASET", @"");

	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont labelFontSize]],
										  NSForegroundColorAttributeName: [UIColor lightGrayColor]};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
