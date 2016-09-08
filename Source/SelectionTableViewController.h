//
//  SelectionTableViewController.h
//  
//
//  Created by Petr Šíma on Apr/29/15.
//
//

@interface SelectionTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *selectedItems; //id<SelectionItem> objects, immutable, KVO compliant
@property (nonatomic, assign) BOOL popsOnSelection; //defaults to YES, only applicable when multipleSelection is NO;

-(instancetype)initWithMultipleSelection:(BOOL)allowsMultipleSelection;

+(NSString *)cellIdentifier;

#pragma mark subclass
-(void)adjustSelectedItems; //abstract
-(NSArray *)indexPathsForSelectedItems;
-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
