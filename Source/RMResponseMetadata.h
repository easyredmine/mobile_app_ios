//
//  RMResponseMetadata.h
//
//  Created by Petr Sima on Mar/15/15
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RMResponseMetadata : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
