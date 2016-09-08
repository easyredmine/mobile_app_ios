//
//  FileUITableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 03/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "FileUITableViewCell.h"

@implementation FileUITableViewCell


// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"FileUITableViewCell";
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
    
    UIImageView *fileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attachment_icon"]];
    [self.contentView addSubview:fileIcon];
    [fileIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];

    
    UIView *contentView = self.contentView;
    UILabel *descriptionLabel = [UILabel new];
    
    descriptionLabel.numberOfLines = 1;
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    descriptionLabel.textColor = kTextFilterGrayColor;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.lessThanOrEqualTo(fileIcon.mas_left).with.offset(10);
        make.centerY.equalTo(contentView);
    }];
    self.descriptionLabel = descriptionLabel;
    
    
   
    
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(File *)file;
{
    self.descriptionLabel.text = file.fileName;

}
@end
