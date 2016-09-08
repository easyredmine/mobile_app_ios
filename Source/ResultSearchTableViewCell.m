//
//  ResultSearchTableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 18/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "ResultSearchTableViewCell.h"

@implementation ResultSearchTableViewCell


// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"ResultSearchTableViewCell";


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
    
    return 44.0;
}

// ------------------------------------------------------------------------
#pragma mark - Lifecycle
// ------------------------------------------------------------------------

-(void)prepareForReuse
{
	[super prepareForReuse];
	self.delimiter.backgroundColor = kColorMain;
	self.selectedBackgroundView.backgroundColor = kColorMain;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setClipsToBounds:YES];
    
    UILabel *textUILabel = [UILabel new];
	textUILabel.numberOfLines = 0;
    [textUILabel setTextColor:[UIColor whiteColor]];

    [self.contentView addSubview:textUILabel];
    [textUILabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(40);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
		 make.top.and.bottom.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(8, 0, 8, 0));
    }];
    self.textUILabel = textUILabel;
    
    UIView *delimiterView = [UIView new];
    [self.contentView addSubview:delimiterView ];
    [delimiterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(textUILabel.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    delimiterView.backgroundColor = kColorMain;
	self.delimiter = delimiterView;
	
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = kColorMain;
    [self setSelectedBackgroundView:bgColorView];
    

    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(Project *)model
{
    [self.contentView setBackgroundColor:kColorMainDark];
    self.textUILabel.text = model.name;
}

@end
