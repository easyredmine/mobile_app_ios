//
//  IssueTableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 18/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssueTableViewCell.h"

@implementation IssueTableViewCell


// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"IssueTableViewCell";
static float cellHeight = 108.;

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
    
    UILabel *priorityLabel = [UILabel new];
    [priorityLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    priorityLabel.textColor = kColorMain;
    [contentView addSubview:priorityLabel];
    [priorityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.top.equalTo(contentView.mas_top).with.offset(15);
    }];

    //neni to imageView z dovodu bodouciho rozsireni
    UIButton *favoriteButton = [UIButton new];
    [contentView addSubview:favoriteButton];
    [favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.top.equalTo(priorityLabel.mas_top);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    favoriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    favoriteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    UILabel *descriptionLabel = [UILabel new];
    
    descriptionLabel.numberOfLines = 1; //zde se to nebude zalamovat detailnejsi popis bude v detailu videt MP naridil
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priorityLabel.mas_left);
        make.right.equalTo(favoriteButton.mas_left);
        make.top.equalTo(priorityLabel.mas_bottom);
        
    }];
    self.descriptionLabel = descriptionLabel;
    
    
    UILabel *authorNameLabel = [UILabel new];
    [authorNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [contentView addSubview:authorNameLabel];
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priorityLabel.mas_left);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.top.equalTo(descriptionLabel.mas_bottom).with.offset(4);
    }];
    self.authorNameLabel = authorNameLabel;
    

    UILabel *dueDateLabel = [UILabel new];
      [dueDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    dueDateLabel.textColor = kTextFilterGrayColor;
    [contentView addSubview:dueDateLabel];
    [dueDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priorityLabel.mas_left);
        make.top.equalTo(authorNameLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(@-15);
    }];
	dueDateLabel.text = NSLocalizedString(@"project_detail_due_date", @"");

    self.dueDateLabel = dueDateLabel;
    
    
    UILabel *dueDateTextLabel = [UILabel new];
    
    [dueDateTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    dueDateTextLabel.textColor = kTextFilterGrayColor;
    [contentView addSubview:dueDateTextLabel];
    [dueDateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dueDateLabel.mas_right).with.offset(3);
        make.bottom.equalTo(dueDateLabel.mas_bottom);
        

    }];
    self.dueDateTextLabel = dueDateTextLabel;
    
    
    UILabel *percentLabel = [UILabel new];
    [percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    percentLabel.textColor = kTextFilterGrayColor;
    [contentView addSubview:percentLabel];
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-15);
    }];
    self.percentLabel = percentLabel;
    
    
//    UIView *delimiterDownView = [UIView new];
//    [contentView addSubview:delimiterDownView ];
//    [delimiterDownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(contentView.mas_bottom).with.offset(-2);
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.height.mas_equalTo(1);
//    }];
//    delimiterDownView.backgroundColor = kDelimiterFilterGrayColor;
    
    
    [favoriteButton setImage:[RedmineUI imageNamed:@"star_deselect"] forState:UIControlStateNormal];
    self.favoriteButton = favoriteButton;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.equalTo(self);
    }];

    
    priorityLabel.numberOfLines = 0;

    self.priorityLabel = priorityLabel;

    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(Issue *)model
{
   
    self.priorityLabel.text = model.priority.name.uppercaseString;
    self.descriptionLabel.text = model.subject;
	self.authorNameLabel.text = model.assignedTo.name ?: NSLocalizedString(@"\u2014", @"");
	self.authorNameLabel.textColor = model.assignedTo.name ? [UIColor darkTextColor] : [UIColor lightGrayColor];

	
    if (model.dueDate) {
            
        NSDateFormatter *formatterOut = [[NSDateFormatter alloc] init];
        [formatterOut setDateFormat:@"dd.MM.yyyy"];
        
        self.dueDateTextLabel.text = [formatterOut  stringFromDate:model.dueDate];
        if (([[NSDate date]compare:model.dueDate])== NSOrderedDescending) {
            self.dueDateTextLabel.textColor = [UIColor redColor];
            self.dueDateLabel.textColor = [UIColor redColor];
                
        }else{
            self.dueDateTextLabel.textColor = kTextFilterGrayColor;
            self.dueDateLabel.textColor = kTextFilterGrayColor;
        }
    }else{
        self.dueDateTextLabel.textColor = kTextFilterGrayColor;
        self.dueDateLabel.textColor = kTextFilterGrayColor;
        self.dueDateTextLabel.text = @"- -";
    }
    
    if ([[[Brand sharedVisual] getCurrentBrand] isEqualToString:kEasyRedmine]) {
        if (model.isFavoritedValue) {
            [self.favoriteButton setImage:[RedmineUI imageNamed:@"star_selected"] forState:UIControlStateNormal];
            
        }else{
            [self.favoriteButton setImage:[RedmineUI imageNamed:@"star_deselect"] forState:UIControlStateNormal];
        }
        
    }else{
        [self.favoriteButton setHidden:YES];
    }
    

    self.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)model.doneRatioValue];
}
@end
