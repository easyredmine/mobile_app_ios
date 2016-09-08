//
//  SelectionTableViewController.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectionTableViewController.h"

@interface SingleSectionSelectionTableViewController : SelectionTableViewController

@property (nonatomic, copy, readonly) NSArray *items;

-(instancetype)initWithItems:(NSArray *)items multipleSelection:(BOOL)multipleSelection;
-(instancetype)initWithItems:(NSArray *)items multipleSelection:(BOOL)multipleSelection searchEnabled:(BOOL)searchEnabled;


@end
