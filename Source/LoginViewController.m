//
//  LoginViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextFiledsView.h"
#import "LoginUITextField.h"

#import "IssuesViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "MenuTableViewController.h"
#import "IQKeyboardManager.h"
#import "EasyRMAlerts.h"
#import <UIAlertView+Blocks.h>
#import <AFNetworking.h>
@interface LoginViewController ()

@property (strong,nonatomic) LoginUITextField *lastActiveTextField;
@property (strong,nonatomic) UILabel *lastActiveTextLabel;
@property (strong,nonatomic) LoginTextFiledsView *loginView;
@property (strong,nonatomic) UIScrollView *scrollView;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated
{

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@20);
    }];
    
    LoginTextFiledsView *loginView = [LoginTextFiledsView new];
    [scrollView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.equalTo(scrollView);
        make.bottom.equalTo(@0);
    }];
	
	loginView.showsEmailAndPhone = ![[[Brand sharedVisual] getCurrentBrand] isEqual:kEasyRedmine];
    self.view.backgroundColor = [UIColor whiteColor];
    [[IQKeyboardManager sharedManager] setEnable:YES];
  
    [loginView.domainTextField setDelegate:self];
    [loginView.usernameTextField setDelegate:self];
    [loginView.passwordTextField setDelegate:self];
	[loginView.emailTextField setDelegate:self];
	[loginView.phoneTextField setDelegate:self];
	
    [loginView.switchRedminesUIButton addTarget:self
                                         action:@selector(switchRedmines:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [loginView.signUIButton addTarget:self
                               action:@selector(signTouch:)
                     forControlEvents:UIControlEventTouchUpInside];
    self.lastActiveTextField = nil;
    self.loginView = loginView;
	self.loginView.domainTextLabel.text = NSLocalizedString(@"login_server_url_easyrm", @"");

#warning remove before release
#ifdef DEBUG
    [self debugSetRedminesTextFields];
#endif
}

#warning remove before release
#ifdef DEBUG
-(void) debugSetRedminesTextFields
{
    if ([[[Brand sharedVisual] getCurrentBrand] isEqual:kEasyRedmine]) {
        [self.loginView.domainTextField setText:@""];
        [self.loginView.usernameTextField setText:@""];
        [self.loginView.passwordTextField setText:@""];
    }else{
        [self.loginView.domainTextField setText:@""];
        [self.loginView.usernameTextField setText:@""];
        [self.loginView.passwordTextField setText:@""];
    }
}
#endif

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden: YES animated:YES];
     [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void) switchRedmines:(UIButton *)item
{
    [[Brand sharedVisual] switchBrand];
	self.loginView.showsEmailAndPhone = !self.loginView.showsEmailAndPhone;
    [self.loginView.switchRedminesUIButton setTitleColor:[self getColorForSwitchButton] forState:UIControlStateNormal];
    [self.loginView.switchRedminesUIButton setTitle:[self getLabelForSwitchButton] forState:UIControlStateNormal];
    self.loginView.signUIButton.backgroundColor = kColorMain;
    [self.loginView.logoImageView setImage:[RedmineUI imageNamed:@"logo"]];
    
    if ([[[Brand sharedVisual] getCurrentBrand] isEqual:kEasyRedmine]) {
        self.loginView.domainTextLabel.text = NSLocalizedString(@"login_server_url_easyrm", @"");
    }else{
		 self.loginView.domainTextLabel.text = NSLocalizedString(@"login_server_url", @"");
    }
    if (self.lastActiveTextField) {
         [self setLabel:self.lastActiveTextLabel andTextField:self.lastActiveTextField toColor:kColorMain];
    }
    [[UINavigationBar appearance] setBarTintColor:kColorMain];
    
#warning remove before release
#ifdef DEBUG
    [self debugSetRedminesTextFields];
    
#endif
}

-(void) getTrial:(UIBarButtonItem *)item
{
    WebViewController *tmp = [WebViewController new];
    [tmp startRequest];
    [self.navigationController pushViewController:tmp animated:YES];
}

-(void) signTouch:(UIButton *)button
{
    if (self.lastActiveTextField) {
        [self setLabel:self.lastActiveTextLabel andTextField:self.lastActiveTextField toColor:kGrayColor];
        [self.lastActiveTextField resignFirstResponder];
        
    }
    TRC_ENTRY;
    TRC_LOG(@"SIGN BUTTON TOUCH: domain: %@, user: %@, password: %@",self.loginView.domainTextField.text,self.loginView.usernameTextField.text,self.loginView.passwordTextField.text);
	
    if (![self.loginView.domainTextField.text length] || ![self.loginView.usernameTextField.text length] || ![self.loginView.passwordTextField.text length]) {
        [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"alert_empty_fields", @"") andDescription:@"" block:^{
            ;
        }];
        return;
    }
	
		NSString __block *urlString = self.loginView.domainTextField.text;
	void(^alertCompletion)(NSString *) = ^(NSString *urlPrefix){
		if(urlPrefix){
			urlString = [urlPrefix stringByAppendingString:urlString];
		}
		NSManagedObjectContext *credContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
		UserCredentials *cred = [UserCredentials MR_createInContext:credContext];
		cred.baseUrlString = urlString;
		cred.username = self.loginView.usernameTextField.text;
		cred.password = self.loginView.passwordTextField.text;
		
		[SVProgressHUD show];
		self.view.userInteractionEnabled = NO;
		button.enabled = NO;
		
		
		RMApiType apiType = [[UserDefaults stringForKey:kBrandKey] isEqualToString:kEasyRedmine] ? RMApiTypeEasyRM : RMApiTypeOriginal;
		RACSignal *loginSignal = [[[DataService sharedService] loginAndDownloadProjectsWithUserCredentials:cred apiType:apiType]
										  
										  doNext:^(id x) {
											  [credContext MR_saveOnlySelfAndWait]; //synchronously merge to main context
											  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil]; //persist main context
										  }];
		
		[[loginSignal finally:^{
			button.enabled = YES;
		self.view.userInteractionEnabled = YES;
			[SVProgressHUD dismiss];
		}]
		 subscribeError:^(NSError *error) {
			 TRC_OBJ(error);
			 NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
			 if(response){
				 NSUInteger statusCode = response.statusCode;
				 switch (statusCode) {
					 case 401:
					 {
							[EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"bad_credentials", @"") block:^{
								;
							}];
					 }
						 break;
					 default:
					 {
						 [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"server_undefined_error", @"") block:^{
							 ;
						 }];
					 }
				 }
			 }else if(error.code == -1003){
				 [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"server_not_found", @"") block:^{
					 ;
				 }];
				 
			 }else{
				 [EasyRMAlerts showAlertWithTitle:NSLocalizedString(@"error", @"") andDescription:NSLocalizedString(@"errorConnection", @"") block:^{
					 ;
				 }];
			 }
			 
			 //[SVProgressHUD dismiss]; //pokud chces neco delat v pripade error i completed, muzes do signalu (jeste pred subscription) vlozit sideffect pomoci finally:, viz napr. ProjectDetailViewController
			 
//			 button.userInteractionEnabled = YES;
		 } completed:^{
			 // [SVProgressHUD dismiss];
//			 button.userInteractionEnabled = YES;
			 
			 //email and phone
			 //make the call from here to make sure DataService -sessionManager had been initialized
			 if((self.loginView.emailTextField.text && ![self.loginView.emailTextField.text isEqualToString:@""] && ![[[Brand sharedVisual] getCurrentBrand] isEqual:kEasyRedmine])
				 || (self.loginView.phoneTextField.text && ![self.loginView.phoneTextField.text isEqualToString:@""])) {
				 [[DataService sharedService] sendEmail:self.loginView.emailTextField.text andPhone:self.loginView.phoneTextField.text];
			 }

			 
			 
			 [UserDefaults setBool:YES forKey:kAlreadyLogged];
			 [UserDefaults setBool:YES forKey:kIsLogged];
			 [UserDefaults setObject:urlString forKey:kLogedBaseUrl];
			 [UserDefaults synchronize];
			 
			 
			 self.view.window.tintColor = [[Brand sharedVisual] mainColor];
			 IssuesViewController *issueViewController = [[IssuesViewController alloc] init];
			 //		 [self.navigationController pushViewController:issueViewController animated:NO];
			 self.navigationController.viewControllers = @[issueViewController];
			 //         AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
			 //         [appdelegate anchorRight];
		 }];
		
		
		
		//download queries
		//TODO: decide where to move this logic when app doesnt always start with login controller
		[loginSignal
		 subscribeError:^(NSError *error) {
			 TRC_OBJ(error)
		 } completed:^{
			 [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
		 }];
		

	};
	
	assert(urlString != nil && ![urlString isEqualToString:@""]); // data should be validated, should get here with empty string
	NSRange httpRange = [urlString rangeOfString:@"http://"];
	NSRange httpsRange = [urlString rangeOfString:@"https://"];
	if(httpRange.location != 0 && httpsRange.location != 0){
		[UIAlertView showWithTitle:NSLocalizedString(@"alert_login_protocol", @"") message:NSLocalizedString(@"alert_login_protocol_msg", @"")  cancelButtonTitle:nil otherButtonTitles:@[@"HTTP", @"HTTPS"] tapBlock:^(UIAlertView *a, NSInteger index){
			if(index == 0){
				alertCompletion(@"http://");
			}else{
				alertCompletion(@"https://");
			}
		}];
	}else{
		alertCompletion(nil);
	}
	
}

-(NSString*)getLabelForSwitchButton
{
    if ([[[Brand sharedVisual] getCurrentBrand] isEqual:kRedmine])
    {
        return NSLocalizedString(@"switch_to_easy_redmine", @"");
    }
    return NSLocalizedString(@"switch_to_redmine", @"");
}

-(UIColor*)getColorForSwitchButton
{
    if ([[[Brand sharedVisual] getCurrentBrand] isEqual:kRedmine])
    {
        return kEasyRedmineColor;
    }
    return kRedmineColor;
}

- (void)textFieldDidEndEditing:(LoginUITextField *)textField
{
    if (self.lastActiveTextField) {
        [self setLabel:self.lastActiveTextLabel andTextField:self.lastActiveTextField toColor:kGrayColor];
        self.lastActiveTextField = nil;
    }
}

- (void)textFieldDidBeginEditing:(LoginUITextField *)textField
{
    if (self.lastActiveTextField) {
        [self setLabel:self.lastActiveTextLabel andTextField:self.lastActiveTextField toColor:kGrayColor];
    }
    
    if (textField == self.loginView.domainTextField) {
        [self setLabel:self.loginView.domainTextLabel andTextField:textField toColor:kColorMain];
        self.lastActiveTextField = textField;
        self.lastActiveTextLabel = self.loginView.domainTextLabel;
        
    }  else if (textField == self.loginView.usernameTextField) {
        [self setLabel:self.loginView.usernameTextLabel andTextField:textField toColor:kColorMain];
        self.lastActiveTextField = textField;
        self.lastActiveTextLabel = self.loginView.usernameTextLabel;
        
    }  else if (textField == self.loginView.passwordTextField) {
        [self setLabel:self.loginView.passwordTextLabel andTextField:textField toColor:kColorMain];
        self.lastActiveTextField = textField;
        self.lastActiveTextLabel = self.loginView.passwordTextLabel;
	 } else if (textField == self.loginView.emailTextField) {
		 [self setLabel:nil andTextField:textField toColor:kColorMain];
		 self.lastActiveTextField = textField;
		 self.lastActiveTextLabel = nil;
	 }
	 else if (textField == self.loginView.phoneTextField) {
		 [self setLabel:nil andTextField:textField toColor:kColorMain];
		 self.lastActiveTextField = textField;
		 self.lastActiveTextLabel = nil;
	 }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginView.domainTextField) {
        [self.loginView.usernameTextField becomeFirstResponder];
    } else if(textField == self.loginView.usernameTextField)  {
        [self.loginView.passwordTextField becomeFirstResponder];
    }else if (textField == self.loginView.passwordTextField) {
		 [self.loginView.emailTextField becomeFirstResponder];
	 }else if (textField == self.loginView.emailTextField) {
		 [self.loginView.phoneTextField becomeFirstResponder];
	 }else {
        [textField resignFirstResponder];
        [self signTouch:nil];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLabel:(UILabel*)label andTextField:(LoginUITextField*)textField toColor:(UIColor*)color
{
    label.textColor = color;
    textField.layer.borderColor = [color CGColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}


@end
