//
//  SectionInfo.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 02/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SectionInfo : NSObject

@property (nonatomic) int countInSection;
@property (strong,nonatomic) NSString *name;
@property (nonatomic) BOOL open;

@end
