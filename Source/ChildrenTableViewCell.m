//
//  ChildrenTableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 06/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "ChildrenTableViewCell.h"

@implementation ChildrenTableViewCell

// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"ChildrenTableViewCell";
static float cellHeight = 44.0;

// ------------------------------------------------------------------------
#pragma mark - Static Methods
// ------------------------------------------------------------------------

+ (NSString *)cellIdentifier
{
    return cellIdentifier;
}

// ------------------------------------------------------------------------
#pragma mark - Public Methods
// ------------------------------------------------------------------------

+ (CGFloat)cellHeight
{
    return cellHeight;
}

// ------------------------------------------------------------------------
#pragma mark - Lifecycle
// ------------------------------------------------------------------------
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setClipsToBounds:YES];
    
    UIView *contentView = self.contentView;
    UILabel *descriptionLabel = [UILabel new];
    
    descriptionLabel.numberOfLines = 1;
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    
    descriptionLabel.textColor = kColorMain;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.centerY.equalTo(contentView);
    }];
    self.descriptionLabel = descriptionLabel;
    
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(Issue *)issue;
{
    self.descriptionLabel.text = issue.name;
}
@end
