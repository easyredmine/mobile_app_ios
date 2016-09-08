//
//  WebViewController.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 16/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>

-(void)startRequest;
@property (nonatomic, strong) NSURL *url;
@end
