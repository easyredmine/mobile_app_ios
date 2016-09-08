//
//  RedmineUI.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "RedmineUI.h"

@implementation RedmineUI


+ (UIImage *)imageNamed:(NSString *)name {
    UIImage* img;
    img = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%@",[[Brand sharedVisual] getCurrentBrand],name]];
    
    if(!img) {
        img = [UIImage imageNamed:name];
    }
    return img;
}

@end
