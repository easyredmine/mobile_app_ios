//
//  EasyRMAlerts.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 26/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EasyRMAlerts.h"
#import <UIAlertView+Blocks.h>
@implementation EasyRMAlerts
+ (void) showAlertWithTitle:(NSString *) title andDescription:(NSString*)message block:(AlertSuccessBlock) successBlock
{
    [UIAlertView showWithTitle:title
                       message:message
				 cancelButtonTitle:NSLocalizedString(@"ok", @"")
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if(successBlock && buttonIndex == 0) {
                              successBlock();
                          }
                          
                      }];
}


+ (void) showDialogWithTitle:(NSString *) title andDescription:(NSString*)message block:(AlertSuccessBlock) successBlock
{
    [UIAlertView showWithTitle:title
                       message:message
             cancelButtonTitle:NSLocalizedString(@"ok", @"")
				 otherButtonTitles:@[NSLocalizedString(@"cancel", @"")
]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if(successBlock && buttonIndex == 0) {
                              successBlock();
                          }
                          
                      }];
}
@end
