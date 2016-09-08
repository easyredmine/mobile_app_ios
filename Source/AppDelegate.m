//
//  AppDelegate.m
//  ProjectName
//
//  Created by Dominik Vesely on 18/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "IssuesViewController.h"
#import "MenuTableViewController.h"
#import "IQKeyboardManager.h"
#import "MenuTableViewController.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "NewIssueViewController.h"

@interface AppDelegate() <ECSlidingViewControllerDelegate, UIAlertViewDelegate>{
}


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Defaults
    NSDictionary *appDefaults = @{ @"BITCrashManagerStatus" : @(BITCrashManagerStatusAutoSend)};
    [UserDefaults registerDefaults:appDefaults];
    [UserDefaults synchronize];
    
    
    [Flurry startSession:kFlurryID];
    [SVProgressHUD setBackgroundColor:kColorMain];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
	[MagicalRecord setupAutoMigratingCoreDataStack];
	
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    MenuTableViewController * menu =[[MenuTableViewController alloc] init];
	UINavigationController * navigationController;
	if(![UserDefaults boolForKey:kIsLogged]){
		LoginViewController* loginVC = [LoginViewController new];
		navigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];;
	}else{
		RMApiType apiType = [[UserDefaults stringForKey:kBrandKey] isEqualToString:kEasyRedmine] ? RMApiTypeEasyRM : RMApiTypeOriginal;
		IssuesViewController * homeVC =[[IssuesViewController alloc] init];
		navigationController = [[UINavigationController alloc]initWithRootViewController:homeVC];;
		[[[DataService sharedService] loginAndDownloadProjectsWithUserCredentials:[UserCredentials MR_findFirst] apiType:apiType] subscribeCompleted:^{}]; // must call this method to setup dataservice session, TODO: bad design, refactor login logic
	}
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:navigationController];
    self.slidingViewController.anchorRightPeekAmount = 70;
    self.slidingViewController.underLeftViewController = menu;
	self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.window.rootViewController = self.slidingViewController;
	
	[self setupNavigationBar];
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self.window makeKeyAndVisible];

	EditedIssue *savedIssue = [[DataService sharedService] getSavedIssue];
	if(savedIssue){
		[[DataService sharedService] removeSavedIssue];
		UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"saved_issue_title", @"")
																  message:NSLocalizedString(@"saved_issue_subtitle", @"")
																 delegate:self cancelButtonTitle:NSLocalizedString(@"saved_issue_delete", @"")
													 otherButtonTitles:NSLocalizedString(@"saved_issue_show", @"")
,nil];
		RACSignal *dismissSignal = [self rac_signalForSelector:@selector(alertView:didDismissWithButtonIndex:) fromProtocol:@protocol(UIAlertViewDelegate)];
		[[dismissSignal take:1] subscribeNext:^(RACTuple *args) {
			NSUInteger buttonIndex = [args.second unsignedIntegerValue];
			switch (buttonIndex) {
				case 1:
				{
					assert([navigationController.topViewController isKindOfClass:[IssuesViewController class]]);
					NewIssueViewController *editVC = [[NewIssueViewController alloc] initWithEditedIssue:savedIssue];
					UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:editVC];
					[navigationController.topViewController presentViewController:navC animated:YES completion:nil];
				}
					break;
				case 0:
				default:
					break;
			}
		}];
		
		[a show];
	}
	
	self.window.tintColor = [[Brand sharedVisual] mainColor];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	
	id rootController = self.window.rootViewController;
	if([rootController isKindOfClass:[ECSlidingViewController class]]){
		id navController = [rootController topViewController];
		if([navController isKindOfClass:[UINavigationController class]]){
			UIViewController *topController = [navController topViewController];
			id presentedNavController = topController.presentedViewController;
			if ([presentedNavController isKindOfClass:[UINavigationController class]]){
				id presentedController = [presentedNavController topViewController];
				if([presentedController isKindOfClass:[NewIssueViewController class]]){
					EditedIssue *issue = [(NewIssueViewController *)presentedController issue];
					[[DataService sharedService] saveIssueForLater:issue];
				}
			}
			
		}
		
	}
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - BITCrashManagerDelegate

- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager {
    
}

- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error {
    
}

- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager {
    
}

- (void)setupNavigationBar  {
    // Background color
    UIColor *navigationBarColor = kColorMain;
    [[UINavigationBar appearance] setBarTintColor:navigationBarColor];
    // Font color
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0], NSFontAttributeName, nil]];
    
    
    // Back button
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // White status bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //  [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//	[[UINavigationBar appearance] setTranslucent:NO];
	
}

- (void)anchorRight
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (void)anchorLeft
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}




@end
