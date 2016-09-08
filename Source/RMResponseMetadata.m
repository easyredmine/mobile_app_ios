//
//  RMResponseMetadata.m
//
//  Created by Petr Sima on Mar/15/15
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import "RMResponseMetadata.h"


NSString *const kRMResponseMetadataTotalCount = @"total_count";
NSString *const kRMResponseMetadataOffset = @"offset";
NSString *const kRMResponseMetadataLimit = @"limit";


@interface RMResponseMetadata ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RMResponseMetadata

@synthesize totalCount = _totalCount;
@synthesize offset = _offset;
@synthesize limit = _limit;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.totalCount = [[self objectOrNilForKey:kRMResponseMetadataTotalCount fromDictionary:dict] integerValue];
            self.offset = [[self objectOrNilForKey:kRMResponseMetadataOffset fromDictionary:dict] integerValue];
            self.limit = [[self objectOrNilForKey:kRMResponseMetadataLimit fromDictionary:dict] integerValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.totalCount] forKey:kRMResponseMetadataTotalCount];
    [mutableDict setValue:[NSNumber numberWithInteger:self.offset] forKey:kRMResponseMetadataOffset];

    [mutableDict setValue:[NSNumber numberWithInteger:self.limit] forKey:kRMResponseMetadataLimit];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.totalCount = [aDecoder decodeDoubleForKey:kRMResponseMetadataTotalCount];
    self.offset = [aDecoder decodeDoubleForKey:kRMResponseMetadataOffset];
    self.limit = [aDecoder decodeDoubleForKey:kRMResponseMetadataLimit];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_totalCount forKey:kRMResponseMetadataTotalCount];
    [aCoder encodeDouble:_offset forKey:kRMResponseMetadataOffset];
    [aCoder encodeDouble:_limit forKey:kRMResponseMetadataLimit];
}

- (id)copyWithZone:(NSZone *)zone
{
    RMResponseMetadata *copy = [[RMResponseMetadata alloc] init];
    
    if (copy) {
        copy.totalCount = self.totalCount;
        copy.offset = self.offset;
        copy.limit = self.limit;
    }
    
    return copy;
}


@end
