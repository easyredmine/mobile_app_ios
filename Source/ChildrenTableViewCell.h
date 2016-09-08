//
//  ChildrenTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 06/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildrenTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel *descriptionLabel;


+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;
- (void)setModel:(Issue *)value;
@end
