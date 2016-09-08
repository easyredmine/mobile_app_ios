//
//  IssueTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 18/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueTableViewCell : UITableViewCell

@property(strong,nonatomic) UILabel *priorityLabel;
@property(strong,nonatomic) UILabel *descriptionLabel;
@property(strong,nonatomic) UILabel *authorNameLabel;
@property(strong,nonatomic) UILabel *dueDateTextLabel;
@property(strong,nonatomic) UILabel *percentLabel;
@property(strong,nonatomic) UIButton *favoriteButton;
@property(strong,nonatomic) UILabel *dueDateLabel;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;
- (void)setModel:(Issue *)model;
@end
