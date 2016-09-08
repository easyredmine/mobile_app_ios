//
//  JournalUITableViewCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 03/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "JournalUITableViewCell.h"
#import "AutoLabel.h"

@implementation JournalUITableViewCell



// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"JournalUITableViewCell";


// ------------------------------------------------------------------------
#pragma mark - Static Methods
// ------------------------------------------------------------------------

+ (NSString *)cellIdentifier
{
    return cellIdentifier;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
	self.autohorLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 2*15; //!!!
	self.descriptionLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 2*15;
}

// ------------------------------------------------------------------------
#pragma mark - Public Methods
// ------------------------------------------------------------------------

- (CGFloat)cellHeight
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 0.5;
}

// ------------------------------------------------------------------------
#pragma mark - Lifecycle
// ------------------------------------------------------------------------


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    UIView *contentView = self.contentView;
 
    
    UILabel *autohorLabel = [UILabel new];
    autohorLabel.numberOfLines = 0;
    [contentView addSubview:autohorLabel];
    [autohorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [autohorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.top.equalTo(contentView.mas_top).with.offset(15);
       
    }];
    self.autohorLabel = autohorLabel;
 
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.numberOfLines = 0; //zde se to nebude zalamovat detailnejsi popis bude v detailu videt MP naridil
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    descriptionLabel.textColor = kTextFilterGrayColor;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.top.equalTo(autohorLabel.mas_bottom).with.offset(15);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-15);
    }];
    self.descriptionLabel = descriptionLabel;
	
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(Journal *)journal
{
    
    NSString *nameOfAuthor = @"unknow";
    if (journal.user.name.length) {
        nameOfAuthor = journal.user.name;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|NSCalendarUnitDay|
                                                         NSCalendarUnitHour | NSCalendarUnitMinute|
                                                         NSCalendarUnitYear)
                                               fromDate:journal.createdOn toDate:[NSDate date] options:0];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSMutableString *timeString = [NSMutableString new];
    
    
    if (year) {
        
        [timeString appendString: [NSString stringWithFormat:@" %ld %@",year, year == 1 ? @"year":@"years"]];
    }
    
    if (month) {
        [timeString appendString: !timeString.length ? @" ":@", " ];
        [timeString appendString: [NSString stringWithFormat:@"%ld %@",month, month == 1 ? @"month":@"months"]];
    }
    
    if (day) {
        [timeString appendString: !timeString.length ? @" ":@", " ];
        [timeString appendString: [NSString stringWithFormat:@"%ld %@",day, day == 1 ? @"day":@"days"]];
    }
    
    if (hour) {
        [timeString appendString: !timeString.length ? @" ":@", " ];
        [timeString appendString: [NSString stringWithFormat:@"%ld %@",hour, hour == 1 ? @"hour":@"hours"]];
    }
    if (minute) {
        [timeString appendString: !timeString.length ? @" ":@", " ];
        [timeString appendString: [NSString stringWithFormat:@"%ld %@",minute, minute == 1 ? @"minute":@"minutes"]];
    }

    [timeString appendString:@" ago"];
    NSArray *stringToFormatArray = @[
                       @[@"by ",kTextFilterGrayColor ],
                       @[nameOfAuthor, kColorMain],
                       @[timeString, kTextFilterGrayColor]
                       ];
    
    NSMutableAttributedString *outFormatString = [[NSMutableAttributedString alloc] initWithString:@""];
   
    for (NSArray *pairOfAtribute in stringToFormatArray) {
        UIColor *color = pairOfAtribute[1];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:(NSString *)pairOfAtribute.firstObject attributes:attributes];
        [outFormatString appendAttributedString:subString];
    }
    
    self.autohorLabel.attributedText = outFormatString;
    self.descriptionLabel.text = journal.truncatedNotes;
}
@end
