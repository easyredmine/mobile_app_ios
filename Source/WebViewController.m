//
//  WebViewController.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 16/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "WebViewController.h"
#import "ACKEnvironment.h"
@interface WebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
     [self.navigationController setNavigationBarHidden: NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"get_free_trial", @"");
    NSURL *url = [NSURL URLWithString:[[[ACKEnvironment sharedEnvironment] getTrialURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self startRequest];
    //^^^^^WTF
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    [self.webView loadRequest:self.urlRequest];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

-(UIWebView *)webView {
    if(!_webView) {
        _webView = [UIWebView new];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.view.userInteractionEnabled = YES;
     [SVProgressHUD dismiss];
}
@end
