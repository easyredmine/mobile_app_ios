//
//  FiltersViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterTableViewCell.h"
#import "FilterSectionHeadrUIView.h"
#import "FilterManager.h"
@interface FiltersViewController ()
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	self.title = NSLocalizedString(@"filters", @"");
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[FilterManager sharedService] loadFilterFromDB];
    [self.tableView registerClass:[FilterTableViewCell class] forCellReuseIdentifier:[FilterTableViewCell cellIdentifier]];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
	self.tableView.tableFooterView = [UIView new];
}


// ------------------------------------------------------------------------
#pragma mark - Table view data source
// ------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[FilterManager sharedService] getNumberOfTableSection];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[FilterManager sharedService] getNumberOfCellInSection:section];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FilterSectionHeadrUIView *sectionView = [[FilterSectionHeadrUIView alloc] init];
    sectionView.textHeaderLabel.text = [[FilterManager sharedService] getLabelForHeadrOfSectionOn:section];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FilterTableViewCell cellIdentifier]];
    cell.filterLabel.text =[[FilterManager sharedService] getLabelForCellOnIndexPath:indexPath];
    [cell  setHighlitedStatus:[[FilterManager sharedService] getStateOfFilterOnIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FilterTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[FilterManager sharedService] changeStateOfFilterOnIndexPath:indexPath];
   // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

-(void)doneBarButtonTouch:(id)sender
{
    TRC_ENTRY;
    TRC_LOG(@"DONE BUTTON PRESSED");
}



@end
