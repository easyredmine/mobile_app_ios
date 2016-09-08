//
//  meta.h
//
//  Created by Petr Sima on Mar/19/15
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface meta : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *issues;
@property (nonatomic, assign) double totalCount;
@property (nonatomic, assign) double offset;
@property (nonatomic, assign) double limit;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
