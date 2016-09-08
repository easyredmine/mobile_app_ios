//
//  ComposerView.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/11/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposerView : UIView

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, weak) UIButton *cameraButton;

@end
