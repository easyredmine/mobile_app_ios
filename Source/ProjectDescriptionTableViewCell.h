//
//  ProjectDescriptionTableViewCell.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 26/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDescriptionTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel *descriptionLabel;


+ (NSString *)cellIdentifier;
- (CGFloat)cellHeight;
- (void)setModel:(NSString *)description;
@end
