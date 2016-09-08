//
//  VariableBrand.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "Brand.h"


//BASIC macros
#define kColorMain [[Brand sharedVisual] mainColor]
#define kColorMainDark [[Brand sharedVisual] mainDarkColor]
//#define kColorText [[Brand sharedVisual] textColor]

//BRAND colors
#define kRedmineColor       [UIColor colorWithHex:0xDB0000]
#define kEasyRedmineColor   [UIColor colorWithHex:0x00A7F8]

#define kRedmineDarkColor       [UIColor colorWithHex:0x8F0B14]
#define kEasyRedmineDarkColor   [UIColor colorWithHex:0x0077A9]



//BRANDS
#define kRedmine    @"redmine"
#define kEasyRedmine @"easyrm"

//HELPERS k
#define kBrandKey @"ActualBrandKey"
#define kBrandSecondRun @"SecondRunBrandKey"





