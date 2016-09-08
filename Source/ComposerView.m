//
//  ComposerView.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/11/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "ComposerView.h"
#import "AutolayoutableTextView.h"
#define kContentInsets UIEdgeInsetsMake(8.,8.,8.,8.)
#define kHorizontalSpacing 8.

#define kMaxTVHeight 120.

@implementation ComposerView

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]){
		[self commonInit];
	}
	return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder]){
		[self commonInit];
	}
	return self;
}

-(void)commonInit
{
    UIView *delimiterDownView = [UIView new];
    [self addSubview:delimiterDownView];
    [delimiterDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.mas_equalTo(1);
    }];
    delimiterDownView.backgroundColor = kGrayColor;
    
    
	UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self addSubview:sendButton];
	[sendButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[sendButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).with.insets(kContentInsets);
		make.top.greaterThanOrEqualTo(self).with.insets(kContentInsets);
		make.bottom.lessThanOrEqualTo(self).with.insets(kContentInsets);
		make.centerY.equalTo(self);
	}];
	self.sendButton = sendButton;
	
	
	UITextView *textView = [AutolayoutableTextView new];
    
    CALayer *layer = textView.layer;
    layer.backgroundColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 1;
    textView.layer.borderColor = [kGrayColor CGColor];

	textView.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    textView.layer.cornerRadius = 4;
	[self addSubview:textView];
	[textView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[textView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.and.bottom.equalTo(self).with.insets(kContentInsets);
		make.right.equalTo(sendButton.mas_left).with.offset(-kHorizontalSpacing);
		make.top.greaterThanOrEqualTo(self).with.insets(kContentInsets);
		make.bottom.lessThanOrEqualTo(self).with.insets(kContentInsets);
        make.left.equalTo(self).with.insets(kContentInsets);
		make.centerY.equalTo(self);
		make.height.lessThanOrEqualTo(@kMaxTVHeight);
	}];
	self.textView = textView;
	
//	UIButton *cameraButton = [UIButton new];
//	[self addSubview:cameraButton];
//	[cameraButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//	[cameraButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//	[cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(self).with.insets(kContentInsets);
//		make.right.equalTo(textView.mas_left).with.offset(-kHorizontalSpacing);
//		make.top.greaterThanOrEqualTo(self).with.insets(kContentInsets);
//        make.bottom.lessThanOrEqualTo(self).with.insets(kContentInsets);
//		make.centerY.equalTo(self);
//	}];
//	self.cameraButton = cameraButton;
	
	RACSignal *textControlSignal = textView.rac_textSignal;
	RACSignal *textProgrammaticSignal = RACObserve(textView, text);

	[[[RACSignal merge:@[textControlSignal,textProgrammaticSignal]] skip:2] subscribeNext:^(id x) {
		[textView invalidateIntrinsicContentSize];
		[textView layoutIfNeeded];
	}];
}

@end
