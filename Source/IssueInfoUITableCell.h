//
//  IssueInfoUITableCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueInfoUITableCell : UITableViewCell
extern NSString *const kIssueInfoUITableCellDescriptionKey;
extern NSString *const kIssueInfoUITableCellLabelKey;

@property(strong,nonatomic) UILabel *descriptionLabel;
@property(strong,nonatomic) UILabel *issueLabel;

+ (NSString *)cellIdentifier;
- (CGFloat)cellHeight;
- (void)setModel:(NSDictionary *)value;
@end
