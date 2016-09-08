//
//  FilterTableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "FilterTableViewCell.h"
@interface FilterTableViewCell()




@end
@implementation FilterTableViewCell

// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"IssueTableViewCell";
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
-(void)setColorToSelected
{
    [self.filterLabel setTextColor:kColorMain];
    [self.filterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
}

-(void)setColorToDiselected
{
    [self.filterLabel setTextColor:[UIColor blackColor]];
    [self.filterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    UILabel *filterLabel = [UILabel new];
    [self.contentView addSubview:filterLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@0);
        make.centerY.equalTo(self);
    }];
    self.filterLabel = filterLabel;
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setHighlitedStatus:(BOOL)status
{
    if (status) {
        [self setColorToSelected];
    }else{
        [self setColorToDiselected];
    }
}


@end
