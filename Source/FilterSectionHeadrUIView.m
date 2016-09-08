//
//  FilterSectionHeadrUIView.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 22/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "FilterSectionHeadrUIView.h"

@implementation FilterSectionHeadrUIView

- (id)init
{

    self = [super init];
    if (self) {
        self.backgroundColor = kBackgroundFilterGrayColor;
        
        UIView *delimiterUpView = [UIView new];
        [self addSubview:delimiterUpView ];
        [delimiterUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(1);
        }];
        delimiterUpView.backgroundColor = kDelimiterFilterGrayColor;
        
        UILabel *textHeaderLabel  = [UILabel new];
        [self addSubview:textHeaderLabel];
        [textHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.bottom.equalTo(@-7);
            
        }];
        [textHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        textHeaderLabel.textColor = kTextFilterGrayColor;
        
        self.textHeaderLabel = textHeaderLabel;
        
        UIView *delimiterDownView = [UIView new];
        [self addSubview:delimiterDownView ];
        [delimiterDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(@0);
           make.right.equalTo(@0);
            make.height.mas_equalTo(1);
        }];
        delimiterDownView.backgroundColor = kDelimiterFilterGrayColor;

    }
    return self;
}




@end
