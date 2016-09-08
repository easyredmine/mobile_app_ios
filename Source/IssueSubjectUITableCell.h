//
//  IssueSubjectUITableCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssueSubjectUITableCell : UITableViewCell
@property(strong,nonatomic) UILabel *descriptionLabel;


+ (NSString *)cellIdentifier;
- (CGFloat)cellHeight;
- (void)setModel:(NSString *)description;
@end