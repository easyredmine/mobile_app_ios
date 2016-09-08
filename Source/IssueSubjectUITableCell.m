//
//  IssueSubjectUITableCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssueSubjectUITableCell.h"

@implementation IssueSubjectUITableCell


// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"IssueSubjectUITableCell";


// ------------------------------------------------------------------------
#pragma mark - Static Methods
// ------------------------------------------------------------------------

+ (NSString *)cellIdentifier
{
    return cellIdentifier;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    self.descriptionLabel.preferredMaxLayoutWidth = self.bounds.size.width;
}

// ------------------------------------------------------------------------
#pragma mark - Public Methods
// ------------------------------------------------------------------------

- (CGFloat)cellHeight
{
    [super layoutSubviews];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
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
    
    descriptionLabel.numberOfLines = 0; //zde se to nebude zalamovat detailnejsi popis bude v detailu videt MP naridil
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    descriptionLabel.textColor = kTextFilterGrayColor;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.top.equalTo(contentView.mas_top).with.offset(15);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-15);
        
        
    }];
    self.descriptionLabel = descriptionLabel;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.equalTo(self);
    }];
    
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(NSString *)description;
{
    self.descriptionLabel.text = description;
}

@end
