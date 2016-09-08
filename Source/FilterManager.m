//
//  Filter.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 21/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "FilterManager.h"

NSString *const FilterChangedNotificationName = @"FilterChanged";

@interface FilterManager(){
}
@property(strong,nonatomic) NSIndexPath* lastSelected;
@property(strong,nonatomic) NSDictionary *defaultFilter;
@property (strong,nonatomic) NSMutableArray *labelsHeaders;
@property (strong,nonatomic) NSArray *defaultFilters;
@property (strong,nonatomic) NSArray *privateFilters;
@property (strong,nonatomic) NSArray *publicFilters;
@property (strong,nonatomic) NSArray *filters;
@property (nonatomic, readonly) Filter *assignToMe;
@property (nonatomic, readonly) Filter *none;

@end

@implementation FilterManager

+(instancetype)sharedService
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self new];
    });
}

-(Filter *)none
{
	return [self.defaultFilters.rac_sequence filter:^BOOL(Filter *value) {
		return [[value type] isEqualToString:@"None"];
	}].array.firstObject;
}

-(Filter *)assignToMe
{
	return [self.defaultFilters.rac_sequence filter:^BOOL(Filter *value) {
		return [[value type] isEqualToString:@"Assign to me"];
	}].array.firstObject;
}

-(instancetype)init
{
    if(self = [super init]){
        [self loadFiltersDefault];
        if (!self.defaultFilters.count) {
			  Filter *none = [[Filter alloc] init];
			  none.name = NSLocalizedString(@"filter_all_tasks", @"");
			  none.type = @"None";
			  none.urlParametrs = @{};
			  none.isEnable = NO;
			  
            Filter *favorite = [[Filter alloc] init];
			  favorite.name = NSLocalizedString(@"filter_favorited", @"");
            favorite.type = @"My favorite";
            favorite.urlParametrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @(1),kFilterFavoriteKey,
                                      @(1),kFilterSetFiltertKey,
                                      nil
                                      ];
            favorite.isEnable = false;
            
            Filter *assignToMe = [[Filter alloc] init];
			  assignToMe.name = NSLocalizedString(@"filter_assigned_to_me", @"")
;
            assignToMe.type = @"Assign to me";
            assignToMe.urlParametrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @(1),kFilterSetFiltertKey,
                                      @"o",kFilterStatusIdKey,
                                      @"me",kFilterAssignedToIdKey,
                                      nil
                                      ];
			  assignToMe.isEnable = false;
			  
            Filter *watchByMe = [[Filter alloc] init];
			  watchByMe.name = NSLocalizedString(@"filter_watched_by_me", @"");

            watchByMe.type = @"Watch by me";
            watchByMe.urlParametrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @(1),kFilterSetFiltertKey,
                                        @"o",kFilterStatusIdKey,
                                        @"me",kFilterWatchIdKey,
                                        nil
                                        ];
            watchByMe.isEnable = false;
            
            Filter *iAmAuthor = [[Filter alloc] init];
			  iAmAuthor.name = NSLocalizedString(@"filter_i_am_author", @"");
            iAmAuthor.type = @"I am author";
            iAmAuthor.urlParametrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @(1),kFilterSetFiltertKey,
                                       @"o",kFilterStatusIdKey,
                                       @"me",kFilterAuthorIdKey,
                                       nil
                                       ];
            iAmAuthor.isEnable = false;
            
            Filter *lastUpdate = [[Filter alloc] init];
			  lastUpdate.name = NSLocalizedString(@"filter_last_updated", @"");
            lastUpdate.type = @"Last update";
            lastUpdate.urlParametrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @(1),kFilterSetFiltertKey,
                                       @"o",kFilterStatusIdKey,
                                       @"7_days",kFilterLastUpdateOnKey,
                                       nil
                                       ];
            lastUpdate.isEnable = false;
            
            self.defaultFilters = @[none, favorite,assignToMe,watchByMe,iAmAuthor,lastUpdate];
            [self saveFiltersDefault];
        }
        
       
		 self.labelsHeaders = [[NSMutableArray alloc] initWithArray:@[NSLocalizedString(@"default_filter", @"")
]];
        [self loadFilterFromDB];
		 [self restoreFilterToDefault];
    }
    return self;
}

-(void)diselectLastSelected
{
    
    for (Filter *filter in self.defaultFilters) {
        if (filter.isEnable) {
            filter.isEnable = NO;
//            [self saveFiltersDefault]; //why save after each iteration? saving has been moved to a single place after all changes are made
        }
    }
    
    for (NSArray *array in self.filters) {
        for (Query *query in array) {
            if (query.isEnable) {
            query.isEnable = [NSNumber numberWithBool:NO];
            }
        }
    }
}

-(void)loadFilterFromDB
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                 ascending:YES];
    NSArray *queries = [Query MR_findAll];
    
    NSPredicate *predicatePublic = [NSPredicate predicateWithFormat:@"isPublic == YES"];
    self.publicFilters = [[queries filteredArrayUsingPredicate:predicatePublic]
                    sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    
    NSPredicate *predicatePrivate = [NSPredicate predicateWithFormat:@"isPublic == NO"];
    self.privateFilters = [[queries filteredArrayUsingPredicate:predicatePrivate]
                          sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] initWithArray:@[@[]]];

    if (self.privateFilters.count) {
        [tempMutableArray addObject:self.privateFilters];
		 [self.labelsHeaders addObject:NSLocalizedString(@"private_filter", @"")
];
    }
    
    if (self.publicFilters.count) {
        [tempMutableArray addObject:self.publicFilters];
		 [self.labelsHeaders addObject:NSLocalizedString(@"public_filter", @"")
];
    }
    
    self.filters = [NSArray arrayWithArray:tempMutableArray];
}

-(void)loadFilterFromUserDefaults
{
    
}

-(void)saveFiltersDefault
{
     NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.defaultFilters];
    [UserDefaults setObject:encodedObject forKey:@"Key"];
    [UserDefaults synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FilterChangedNotificationName object:self];
}

-(void)loadFiltersDefault
{
    
    NSData *encodedObject = [UserDefaults objectForKey:@"Key"];
    self.defaultFilters  = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

-(NSInteger)getNumberOfTableSection
{
    NSInteger countOfSection = 1; // 1 protoze vzdy bude default
    if (self.privateFilters.count ) {
        countOfSection++;
    }
    if (self.publicFilters.count) {
        countOfSection++;
    }
    return countOfSection;
}

-(NSInteger)getNumberOfCellInSection:(NSInteger)section
{
    if(section == 0){
        return self.defaultFilters.count;
    }else {
        NSArray *sectionQueries = self.filters[section];
        return sectionQueries.count;
    }
}

-(NSString*)getLabelForCellOnIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        Filter *filter =  self.defaultFilters[indexPath.row];
        return filter.name;
    }else {
        NSArray *sectionQueries = self.filters [indexPath.section];
        Query *query = sectionQueries[indexPath.row];
        return query.name;
    }
}

-(void)changeStateOfFilterOnIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        Filter *filter =  self.defaultFilters[indexPath.row];
        if (!filter.isEnable) {
            [self diselectLastSelected];
            filter.isEnable =YES;
        }else{
			  //do nothing
//            [self diselectLastSelected];
        }
        
    }else {
        NSArray *sectionQueries = self.filters [indexPath.section];
        Query *query = sectionQueries[indexPath.row];
        if (![query.isEnable boolValue]) {
            [self diselectLastSelected];
             query.isEnable = [NSNumber numberWithBool:YES];
        }else{
			  //do nothing
//            [self diselectLastSelected];
        }
    }
	
	[self saveFiltersDefault]; //save after all changes have been made, dont save in multiple places - fragile code
}

-(BOOL)getStateOfFilterOnIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        Filter *filter =  self.defaultFilters[indexPath.row];
        return filter.isEnable;
    }else {
        NSArray *sectionQueries = self.filters [indexPath.section];
        Query *query = sectionQueries[indexPath.row];
        return [query.isEnable boolValue];
    }
}

-(NSString*)getLabelForHeadrOfSectionOn:(NSInteger)index
{
    return self.labelsHeaders[index];
}

-(NSNumber*)getIdOfEnableQuery
{
    for (NSArray *array in self.filters) {
        for (Query *query in array) {
            if (query.isEnableValue) {
                return query.identifier;
            }
        }
    }
    return nil;
}

-(NSString*)getNameOfActualFilter //current ne actual :D
{
    for (NSArray *array in self.filters) {
        for (Query *query in array) {
            if (query.isEnableValue) {
                return query.name;
            }
        }
    }
    for (Filter *filter in self.defaultFilters) {
        if (filter.isEnable) {
            return filter.name;
        }
    }
    return @"";
}

-(NSDictionary*)getUrlParametersActiveFilter
{
    for (NSArray *array in self.filters) {
        for (Query *query in array) {
            if (query.isEnableValue) {
              return   [[NSDictionary alloc] initWithObjectsAndKeys:
                        query.identifier, kFilterQueryIdKey, nil] ;
            }
        }
    }
    for (Filter *filter in self.defaultFilters) {
        if (filter.isEnable) {
            return filter.urlParametrs ;
        }
    }
	return @{};
}


-(void)restoreFilterToDefault
{
	[self diselectLastSelected];
	self.assignToMe.isEnable = YES;
	[self saveFiltersDefault];
}

@end
