//
//  Filter.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 21/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FilterChangedNotificationName;

@interface FilterManager : NSObject

+(instancetype)sharedService;
-(void)loadFilterFromDB;
-(void)loadFilterFromUserdefaults;
-(void)restoreFilterToDefault;
-(NSInteger)getNumberOfTableSection;
-(NSInteger)getNumberOfCellInSection:(NSInteger)section;
-(NSString*)getLabelForCellOnIndexPath:(NSIndexPath*)path;
-(void)changeStateOfFilterOnIndexPath:(NSIndexPath*)path;
-(BOOL)getStateOfFilterOnIndexPath:(NSIndexPath*)path;
-(NSString*)getLabelForHeadrOfSectionOn:(NSInteger)index;
-(NSNumber*)getIdOfEnableQuery;
-(NSDictionary*)getUrlParametersActiveFilter;
-(NSString*)getNameOfActualFilter;

@end
