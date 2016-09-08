//
//  ResultSearchTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 18/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultSearchTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel *textUILabel;
+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;
- (void)setModel:(Project *)model;


@property (nonatomic, weak) UIView *delimiter;

@end
