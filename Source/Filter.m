//
//  Filter.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "Filter.h"

@implementation Filter


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeBool:self.isEnable forKey:@"isEnable"];
    [encoder encodeObject:self.urlParametrs forKey:@"urlParameter"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.isEnable = [decoder decodeBoolForKey:@"isEnable"];
        self.urlParametrs = [decoder decodeObjectForKey:@"urlParameter"];
    }
    return self;
}
@end
