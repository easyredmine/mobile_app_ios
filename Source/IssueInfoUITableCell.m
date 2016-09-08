//
//  IssueInfoUITableCell.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//


#import "IssueInfoUITableCell.h"
#import "AutoLabel.h"

@implementation IssueInfoUITableCell


// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *cellIdentifier = @"IssueInfoUITableCell";
static float cellHeight = 44.0;
NSString *const kIssueInfoUITableCellDescriptionKey =  @"desciption";
NSString *const kIssueInfoUITableCellLabelKey =  @"label";

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

-(CGFloat)cellHeight
{
	[self setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];

	[self setNeedsLayout];
	[self layoutIfNeeded];
	
	CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	return size.height + 1.;
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
	descriptionLabel.adjustsFontSizeToFitWidth = YES;
	descriptionLabel.minimumScaleFactor = 0.5;
    [contentView addSubview:descriptionLabel];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    descriptionLabel.textColor = kTextFilterGrayColor;
	[descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[descriptionLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(15);
		 make.top.equalTo(contentView).with.offset(14);
		 make.width.lessThanOrEqualTo(contentView).multipliedBy(0.5); //leave some space for content label
    }];
    self.descriptionLabel = descriptionLabel;
    
	
    UILabel *issueLabel = [AutoLabel new];
    
    issueLabel.numberOfLines = 0;
    [contentView addSubview:issueLabel];
    issueLabel.textAlignment = NSTextAlignmentRight;

    [issueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    issueLabel.textColor = kTextFilterGrayColor;
	[issueLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[issueLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	[issueLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[issueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-15);
        make.left.equalTo(descriptionLabel.mas_right).with.offset(10);
		make.top.equalTo(contentView).with.offset(14);
		make.bottom.equalTo(contentView).with.offset(-14).with.priorityLow();
    }];
    self.issueLabel = issueLabel;
    
    return self;
}

// ------------------------------------------------------------------------
#pragma mark - Setter
// ------------------------------------------------------------------------

- (void)setModel:(NSDictionary *)value;
{
    self.descriptionLabel.text = [value objectForKey:kIssueInfoUITableCellDescriptionKey];
    id text = [value objectForKey:kIssueInfoUITableCellLabelKey];
	if([text length] == 0) text = @" "; //empty string fucks up layout
	if([text isKindOfClass:[NSAttributedString class]]){
		self.issueLabel.attributedText = text;
	}else{
		self.issueLabel.text = text;
	}
}
@end
