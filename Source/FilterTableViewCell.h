//
//  FilterTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *filterLabel;
@property(nonatomic) BOOL selectedCell;
+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;
- (void)setHighlitedStatus:(BOOL)status;

@end
