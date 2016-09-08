//
//  MultisectionSelectionTableViewController.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/29/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "SingleSectionSelectionTableViewController.h"

@interface MultiSectionSelectionTableViewController : SelectionTableViewController

@property (nonatomic, strong) NSArray *sections;

-(instancetype)initWithSections:(NSArray *)sections multipleSelection:(BOOL)multipleSelection;

@end
