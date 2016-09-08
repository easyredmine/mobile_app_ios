//
//  ProjectDetailViewController.h
//  EasyRedmine
//
//  Created by Petr Šíma on Mar/19/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
@interface ProjectDetailViewController : MasterMenuViewController

@property (nonatomic, strong, readonly) Project *project;
-(instancetype)initWithProject:(Project *)project;

@end
