//
//  JournalsViewController.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 04/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardLayoutGuideViewController.h"

@interface JournalsViewController : KeyboardLayoutGuideViewController
- (instancetype)initWithJournals:(Issue*)issue andTitle:(NSString*) title;
-(void) keyboardWillShow;
-(void) keyboardWillHide;
@end

