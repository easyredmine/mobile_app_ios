//
//  EditedIssue.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/28/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Mantle.h>

@interface EditedIssue : MTLModel <MTLJSONSerializing>

-(instancetype)initWithIssue:(Issue *)issue;

@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSNumber *doneRatio;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSNumber *estimatedHours;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *isFavorited;
@property (nonatomic, copy) NSString *issueDescription;
@property (nonatomic, strong) NSNumber *spentHours;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) NSDate *updatedOn;
@property (nonatomic, strong) NSDictionary *project;
@property (nonatomic, strong) NSDictionary *assignedTo;
@property (nonatomic, strong) NSDictionary *tracker;
@property (nonatomic, strong) NSDictionary *status;
@property (nonatomic, strong) NSDictionary *priority;
@property (nonatomic, strong) NSDictionary *parent;
@property (nonatomic, strong) NSArray *journals;
@property (nonatomic, strong) NSDictionary *fixedVersion;
@property (nonatomic, strong) NSArray *customFields;
@property (nonatomic, strong) NSDictionary *author;
@property (nonatomic, strong) NSDictionary *category;
@property (nonatomic, strong) NSString *notes;

@property (nonatomic, strong) NSMutableArray *fileUploads;
@property (nonatomic, strong) NSArray *availableProjects;
@property (nonatomic, strong) NSArray *availableAssignees;
@property (nonatomic, strong) NSArray *availableTrackers;
@property (nonatomic, strong) NSArray *availableStatuses;
@property (nonatomic, strong) NSArray *availablePriorities;
@property (nonatomic, strong) NSArray *availableCategories;
@property (nonatomic, strong) NSArray *availableFixedVersions;
@property (nonatomic, strong) NSArray *availableActivities;

@property (nonatomic, strong) NSArray *availableCustomFields;

@end
