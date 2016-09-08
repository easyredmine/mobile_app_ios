//
//  AttachmentWebViewController.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/30/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "AttachmentWebViewController.h"

@implementation AttachmentWebViewController

-(void)loadView
{
	UIWebView *webView = [UIWebView new];
	webView.scalesPageToFit = YES;
	self.view = webView;
}

-(UIWebView *)webView
{
	return (id)self.view;
}

@end
