//
//  LabelViewCell.m
//
//
//  Created by Michal Kučera on 15/12/15.
//
//

#import "LabelViewCell.h"

@implementation LabelViewCell

#define kContentInsets UIEdgeInsetsMake(15,15,15,15)
#define kContentInsetsWithDisclosureIndicator UIEdgeInsetsMake(15,15,15,0)

// ------------------------------------------------------------------------------------------
#pragma mark - Init
// ------------------------------------------------------------------------------------------

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

// ------------------------------------------------------------------------------------------
#pragma mark - Public Method
// ------------------------------------------------------------------------------------------

- (void)setLessMode:(BOOL)selected
{
    if (selected) {
        [self.label setText:NSLocalizedString(@"less", @"")];
        
    } else {
        [self.label setText:NSLocalizedString(@"more", @"")];
    }
    [self.label setTextColor:[[Brand sharedVisual] mainColor]];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Private Method
// ------------------------------------------------------------------------------------------

-(void)setup
{
    UILabel *ll = [UILabel new];
    ll.textColor = [UIColor darkTextColor];
    ll.adjustsFontSizeToFitWidth = YES;
    [ll setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    ll.minimumScaleFactor = 0.5;
    ll.textAlignment = NSTextAlignmentCenter;
    [ll setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:ll];
    [ll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView).with.insets(kContentInsets);
    }];
    self.label = ll;
}

@end
