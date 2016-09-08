//
//  SelectionTableViewController.m
//  
//
//  Created by Petr Šíma on Apr/29/15.
//
//

#import "SelectionTableViewController.h"

@interface SelectionTableViewController(){
}

@property (nonatomic, strong) UITableViewCell *prototypeCell;

@end

@implementation SelectionTableViewController

-(instancetype)initWithMultipleSelection:(BOOL)allowsMultipleSelection;
{
	if(self = [super initWithStyle:UITableViewStylePlain]){
		self.popsOnSelection = YES;
		self.tableView.allowsMultipleSelection = allowsMultipleSelection;
	}
	return self;
}

static NSString *const CellId = @"CellId";

+(NSString *)cellIdentifier
{
	return CellId;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.tableFooterView = [UIView new];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellId];
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.;
	
	self.prototypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] cellIdentifier] forIndexPath:indexPath];
	[self configureCell:cell forRowAtIndexPath:indexPath];
	if([[self indexPathsForSelectedItems] containsObject:indexPath]) {
		[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	}

	return cell;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if([[self indexPathsForSelectedItems] containsObject:indexPath]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}else{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.textLabel.numberOfLines = 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
	[self.prototypeCell setNeedsLayout];
	[self.prototypeCell layoutIfNeeded];
	self.prototypeCell.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, 0);
		self.prototypeCell.textLabel.preferredMaxLayoutWidth = self.prototypeCell.textLabel.bounds.size.width;
	CGSize size = self.prototypeCell.textLabel.intrinsicContentSize;
	return size.height + 44. - 20.5;
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self adjustSelectedItems];
	if(!tableView.allowsMultipleSelection && self.popsOnSelection){
		[self.navigationController popViewControllerAnimated:YES];
	}
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView beginUpdates];
	[tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self adjustSelectedItems];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryNone;
	[tableView beginUpdates];
	[tableView endUpdates];
}

-(void)adjustSelectedItems
{
	assert(NO); //abstract
}
-(NSArray *)indexPathsForSelectedItems
{
	assert(NO); //abstract
}

@end
