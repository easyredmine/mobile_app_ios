//
//  Brand.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

+ (instancetype)sharedVisual;
-(void) setBrand:(NSString*) brand;
-(NSString*) switchBrand;
-(NSString*) getCurrentBrand;
-(UIColor *)mainColor;
-(UIColor *)mainDarkColor;


@end
