//
//  ProjectStatisticTableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 27/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "ProjectStatisticTableViewCell.h"

@implementation ProjectStatisticTableViewCell

// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"ProjectStatisticTableViewCell";


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
    return 44.;
    
}

// ------------------------------------------------------------------------
#pragma mark - Lifecycle
// ------------------------------------------------------------------------


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setClipsToBounds:YES];
    
    UIView *contentView = self.contentView;
    UILabel *descriptionLabel = [UILabel new];
    
    descriptionLabel.numberOfLines = 0; //zde se to nebude zalamovat detailnejsi popis bude v detailu videt MP naridil
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
    descriptionLabel.textColor = kTextFilterGrayColor;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
        
    }];
    self.descriptionTextLabel = descriptionLabel;
    
    
    
    UILabel *valueLabel = [UILabel new];
    
   
    [contentView addSubview:valueLabel];
    [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    valueLabel.textColor = kTextFilterGrayColor;
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
        
    }];
    self.valueLabel = valueLabel;
    
    
    
    UIView *delimiterDownView = [UIView new];
    [self addSubview:delimiterDownView ];
    [delimiterDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@1);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.mas_equalTo(1);
    }];
    delimiterDownView.backgroundColor = kDelimiterFilterGrayColor;
    
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setLabel:(NSString*)description withValue:(NSString*)value
{
    self.descriptionTextLabel.text = description;
    if (value.length) {
        self.valueLabel.text = value;
    }else{
        self.valueLabel.text = @"- -";
    }
    
}


@end
