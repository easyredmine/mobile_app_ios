//
//  Filter.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSDictionary *urlParametrs;
@property(nonatomic) BOOL isEnable;
@end
