//
//  OpenUrlHelper.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 10/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenUrlHelper : NSObject



+(void) openProjectDetail:(Project*)project;
+(void) openIssueDetail:(Issue*)project;
+(void) openIssuesWithFilter;

@end
