//
//  MasterMenuViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 16/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "MasterMenuViewController.h"
#import "AppDelegate.h"

@implementation MasterMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Added icon to nav bar
    UIBarButtonItem *button = [UIBarButtonItem barButtonWithImageNamed:@"menu" target:self action:@selector(toggleMenu)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius  = 10.0f;
    self.navigationController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)toggleMenu
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate anchorRight];
}

@end


