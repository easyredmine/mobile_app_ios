//
//  Custom.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 11/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "LoginUITextField.h"

@implementation LoginUITextField

- (void)drawRect:(CGRect)rect
{
    [self setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    self.textColor = kTextGrayColor;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    CALayer *layer = self.layer;
    layer.backgroundColor = [[UIColor whiteColor] CGColor];
    layer.cornerRadius = 3.5;
    layer.borderWidth = 2;
    self.tintColor = kGrayColor;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 8, bounds.origin.y + 4,
                      bounds.size.width - 16, bounds.size.height - 8);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
