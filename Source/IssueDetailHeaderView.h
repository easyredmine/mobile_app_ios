//
//  IssueDetailHeaderView.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SectionHeaderViewDelegate;

@interface IssueDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UIButton *disclosureButton;
@property (nonatomic, weak)  id <SectionHeaderViewDelegate> delegate;
@property (nonatomic, strong)  UIImageView *arrowDisclosure;

@property (nonatomic) NSInteger section;

@property (nonatomic) BOOL opened;
- (void)toggleOpenWithUserAction:(BOOL)userAction;

+ (NSString *)headerIdentifier;

-(void)setActualStateOfArrow;
@end

#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(IssueDetailHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(IssueDetailHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end