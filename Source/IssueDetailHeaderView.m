//
//  IssueDetailHeaderView.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "IssueDetailHeaderView.h"

@implementation IssueDetailHeaderView
// ------------------------------------------------------------------------
#pragma mark - Contstants
// ------------------------------------------------------------------------

static NSString *headerIdentifier = @"IssueDetailHeaderView";

+ (NSString *)headerIdentifier
{
    return headerIdentifier;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super  initWithReuseIdentifier:reuseIdentifier]){
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

-(void)setup{
    
    UIView *delimiterUpView = [UIView new];
    [self addSubview:delimiterUpView ];
    [delimiterUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.mas_equalTo(2);
    }];
    delimiterUpView.backgroundColor = kDelimiterFilterGrayColor;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
 
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
    }];
    self.titleLabel = titleLabel;
    self.opened = YES;
    
    
    UIImageView *arrowDisclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_disclosure_up"]];
    [self addSubview:arrowDisclosure];
    [arrowDisclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    self.arrowDisclosure = arrowDisclosure;

}

- (void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {

    if (userAction) {
        self.opened =! self.opened;
        [self setActualStateOfArrow];
        if (self.opened) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
      }
    }
}
-(void)setActualStateOfArrow //current - soucasny, actual - opravdovy :D
{
    if (self.opened) {
        [self.arrowDisclosure setImage:[UIImage imageNamed:@"arrow_disclosure_up"]];
    }else{
        [self.arrowDisclosure setImage:[UIImage imageNamed:@"arrow_disclosure_down"]];
    }
}


@end
