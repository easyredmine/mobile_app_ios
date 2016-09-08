//
//  MultisectionSelectionTableViewController.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/29/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "MultiSectionSelectionTableViewController.h"

@interface MultiSectionSelectionTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *filteredData;
@property (nonatomic, strong) NSString *searchText;

@end

@implementation MultiSectionSelectionTableViewController



-(instancetype)initWithSections:(NSArray *)sections multipleSelection:(BOOL)multipleSelection
{
	if(self = [super initWithMultipleSelection:multipleSelection]){
		self.sections = sections;
        self.filteredData = [sections copy];
		[self adjustSelectedItems];
	}
	return self;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
    
    // Add search
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    searchBar.delegate = self;
    [searchBar sizeToFit];
    UISearchDisplayController *controller = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    controller.delegate = self;
    controller.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = controller.searchBar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:self.sections.count];
        for (int i=0; i<self.filteredData.count; i++) {
            [data addObject:@{@"name": self.sections[i][@"name"], @"values": [self.sections[i][@"values"] filteredArrayUsingPredicate:predicate]}];
        }
        self.filteredData = data;
    } else {
        self.filteredData = self.sections;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.filteredData = [self.sections copy];
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

-(NSArray *)indexPathsForSelectedItems
{
	NSMutableArray *indexPaths = [NSMutableArray new];
	for(NSUInteger s = 0; s < self.sections.count; s++){
		NSDictionary *section = self.sections[s];
		for(id selectedItem in self.selectedItems){
			NSUInteger row = [section[@"values"] indexOfObject:selectedItem];
			if(row != NSNotFound){
				[indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:s]];
			}
		}
		
	}
	return [indexPaths copy];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.filteredData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.filteredData[section][@"values"] count];
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
	NSDictionary *item = self.filteredData[indexPath.section][@"values"][indexPath.row];
    NSString *name = item[@"name"];

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
		return self.filteredData[value.section][@"values"][value.row];
	}].array;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.filteredData[section][@"name"];
}

@end
