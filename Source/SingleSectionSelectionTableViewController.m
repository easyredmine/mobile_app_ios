//
//  SelectionTableViewController.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "SingleSectionSelectionTableViewController.h"

@interface SingleSectionSelectionTableViewController() <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *filteredData;
@property (nonatomic, copy, readwrite) NSArray *items;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSNumber *isSearchEnabled;

@end

@implementation SingleSectionSelectionTableViewController

-(instancetype)initWithItems:(NSArray *)items multipleSelection:(BOOL)multipleSelection
{
    if(self = [super initWithMultipleSelection:multipleSelection]){
        self.items = items;
        self.filteredData = items;
        self.isSearchEnabled = @(YES);
        [self adjustSelectedItems];
    }
    return self;
}

-(instancetype)initWithItems:(NSArray *)items multipleSelection:(BOOL)multipleSelection searchEnabled:(BOOL)searchEnabled
{
    if(self = [super initWithMultipleSelection:multipleSelection]){
        self.items = items;
        self.filteredData = items;
        self.isSearchEnabled = @(searchEnabled);
        [self adjustSelectedItems];
    }
    return self;
}

-(NSArray *)indexPathsForSelectedItems
{
    NSMutableArray *indexPaths = [NSMutableArray new];
    for(id selectedItem in self.selectedItems){
        NSUInteger idx = [self.items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = @"value";
            if (!obj[key]) {
                key = @"id";
            }
            
            if([selectedItem isKindOfClass:[NSDictionary class]]){
                *stop = [selectedItem[key] isEqual:obj[key]];
            }else{
                *stop = [selectedItem isEqual:obj[key]];
            }
            return *stop;
        }];
        if(idx != NSNotFound){
            [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    }
    return [indexPaths copy];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.isSearchEnabled boolValue]) {
        // Add search
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        searchBar.delegate = self;
        [searchBar sizeToFit];
        UISearchDisplayController *controller = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        controller.delegate = self;
        controller.searchResultsDataSource = self;
        
        self.tableView.tableHeaderView = controller.searchBar;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tableView.tableHeaderView = nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell forRowAtIndexPath:indexPath];
    id item = self.filteredData[indexPath.row];
    NSString *name = nil;
    if([item isKindOfClass:[NSDictionary class]]){
        name = item[@"name"];
    }else if([item respondsToSelector:@selector(name)]){
        name = [item name];
    }
    
    if (self.searchText.length) {
        NSRange range = [name rangeOfString:self.searchText options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:name];
            NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:17]};
            [attributedName setAttributes:attrs range:range];
            
            cell.textLabel.attributedText = attributedName;
            return;
        }
    } else {
        cell.textLabel.attributedText = nil;
    }
    
    cell.textLabel.text = name;
}

-(void)adjustSelectedItems
{
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    self.selectedItems = [selectedIndexPaths.rac_sequence map:^id(NSIndexPath *value) {
        return self.filteredData[value.row];
    }].array;
}

#pragma mark - Searching

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        NSArray *data = [self.items filteredArrayUsingPredicate:predicate];
        self.filteredData = data;
    } else {
        self.filteredData = self.items;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.filteredData = [self.items copy];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}




@end
