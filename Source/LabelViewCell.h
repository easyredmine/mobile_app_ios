//
//  LabelViewCell.h
//  
//
//  Created by Michal Kučera on 15/12/15.
//
//

#import <UIKit/UIKit.h>

@interface LabelViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *label;

-(void)setLessMode:(BOOL)selected;

@end
