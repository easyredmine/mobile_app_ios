//
//  Brand.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "Brand.h"

@implementation Brand

+ (instancetype)sharedVisual {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[Brand alloc] init];
    });
}

- (instancetype) init {
    self = [super init];
    if(self) {
        if (![UserDefaults boolForKey:kBrandSecondRun]){
            [UserDefaults setBool:YES forKey:kBrandSecondRun];
            //set default brand on init to REDMINE
            [UserDefaults setObject:kEasyRedmine forKey:kBrandKey];
            [UserDefaults synchronize];
        }
    }
    return self;
}

-(void) setBrand:(NSString*) brand {
    [UserDefaults setObject:brand forKey:kBrandKey];
    [UserDefaults synchronize];
    [SVProgressHUD setBackgroundColor:kColorMain];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

-(NSString*) getCurrentBrand {
   return  [UserDefaults stringForKey:kBrandKey];
}

-(NSString*) switchBrand {
    if ([[self getCurrentBrand] isEqual: kRedmine]) {
        [UserDefaults setObject:kEasyRedmine forKey:kBrandKey];
        [UserDefaults synchronize];
        [SVProgressHUD setBackgroundColor:kColorMain];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        return kEasyRedmine;
    }else{
        [UserDefaults setObject:kRedmine forKey:kBrandKey];
        [SVProgressHUD setBackgroundColor:kColorMain];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [UserDefaults synchronize];
        return kRedmine;
    }
}

-(UIColor *)mainColor {
    if ([[self getCurrentBrand] isEqual: kRedmine]) {
        return  kRedmineColor;
    }else if ([[self getCurrentBrand] isEqual:kEasyRedmine]){
        return kEasyRedmineColor;
    }else {
        return  kRedmineColor;
    }
}

-(UIColor *)mainDarkColor {
    if ([[self getCurrentBrand] isEqual: kRedmine]) {
        return  kRedmineDarkColor;
    }else if ([[self getCurrentBrand] isEqual:kEasyRedmine]){
        return kEasyRedmineDarkColor;
    }else {
        return  kRedmineDarkColor;
    }
}
@end
