//
//  SectionInfoIssue.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionInfoIssue : NSObject

@property (nonatomic) int countInSection;
//@property IssueDetailHeaderView *headerView;
//@property (nonatomic) NSMutableArray *rowHeights;
@property (strong,nonatomic) NSString *name;
@property (nonatomic) BOOL open;
@property (nonatomic) BOOL showHeader;
@end
