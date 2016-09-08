//
//  ProjectStatisticTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 27/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectStatisticTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *descriptionTextLabel;
@property (strong,nonatomic) UILabel *valueLabel;
- (void)setLabel:(NSString*)description withValue:(NSString*)value;
+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
