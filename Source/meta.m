//
//  meta.m
//
//  Created by Petr Sima on Mar/19/15
//  Copyright (c) 2015 Petr Sima. All rights reserved.
//

#import "meta.h"
#import "Issues.h"


NSString *const kmetaIssues = @"issues";
NSString *const kmetaTotalCount = @"total_count";
NSString *const kmetaOffset = @"offset";
NSString *const kmetaLimit = @"limit";


@interface meta ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation meta

@synthesize issues = _issues;
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
    NSObject *receivedIssues = [dict objectForKey:kmetaIssues];
    NSMutableArray *parsedIssues = [NSMutableArray array];
    if ([receivedIssues isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedIssues) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedIssues addObject:[Issues modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedIssues isKindOfClass:[NSDictionary class]]) {
       [parsedIssues addObject:[Issues modelObjectWithDictionary:(NSDictionary *)receivedIssues]];
    }

    self.issues = [NSArray arrayWithArray:parsedIssues];
            self.totalCount = [[self objectOrNilForKey:kmetaTotalCount fromDictionary:dict] doubleValue];
            self.offset = [[self objectOrNilForKey:kmetaOffset fromDictionary:dict] doubleValue];
            self.limit = [[self objectOrNilForKey:kmetaLimit fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForIssues = [NSMutableArray array];
    for (NSObject *subArrayObject in self.issues) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForIssues addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForIssues addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForIssues] forKey:kmetaIssues];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kmetaTotalCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.offset] forKey:kmetaOffset];
    [mutableDict setValue:[NSNumber numberWithDouble:self.limit] forKey:kmetaLimit];

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

    self.issues = [aDecoder decodeObjectForKey:kmetaIssues];
    self.totalCount = [aDecoder decodeDoubleForKey:kmetaTotalCount];
    self.offset = [aDecoder decodeDoubleForKey:kmetaOffset];
    self.limit = [aDecoder decodeDoubleForKey:kmetaLimit];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_issues forKey:kmetaIssues];
    [aCoder encodeDouble:_totalCount forKey:kmetaTotalCount];
    [aCoder encodeDouble:_offset forKey:kmetaOffset];
    [aCoder encodeDouble:_limit forKey:kmetaLimit];
}

- (id)copyWithZone:(NSZone *)zone
{
    meta *copy = [[meta alloc] init];
    
    if (copy) {

        copy.issues = [self.issues copyWithZone:zone];
        copy.totalCount = self.totalCount;
        copy.offset = self.offset;
        copy.limit = self.limit;
    }
    
    return copy;
}


@end
