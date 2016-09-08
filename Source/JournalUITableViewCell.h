//
//  JournalUITableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 03/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalUITableViewCell : UITableViewCell

@property(strong,nonatomic) UILabel *descriptionLabel;
@property(strong,nonatomic) UILabel *autohorLabel;


+ (NSString *)cellIdentifier;
- (CGFloat)cellHeight;
- (void)setModel:(Journal *)journal;
@end