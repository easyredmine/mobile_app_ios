//
//  AppDelegate.h
//  ProjectName
//
//  Created by Dominik Vesely on 18/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>
#import <ECSlidingViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BITHockeyManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ECSlidingViewController *slidingViewController;
- (void)anchorRight;
- (void)anchorLeft;
@end
