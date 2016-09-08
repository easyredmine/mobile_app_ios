//
//  EditTextViewCell.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SZTextView.h>

@interface EditTextViewCell : UITableViewCell

@property (nonatomic, weak) SZTextView *textView;

@end
