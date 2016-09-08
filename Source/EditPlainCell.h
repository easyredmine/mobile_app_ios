//
//  EditPushCell.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/1/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPlainCell : UITableViewCell

@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end
