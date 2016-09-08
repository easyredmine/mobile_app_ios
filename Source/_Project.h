// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.h instead.

#import <CoreData/CoreData.h>


extern const struct ProjectAttributes {
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *easyDueDate;
	__unsafe_unretained NSString *homepage;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *isPublic;
	__unsafe_unretained NSString *partialName;
	__unsafe_unretained NSString *projectDescription;
	__unsafe_unretained NSString *projectIdentifier;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *sumEstimatedHours;
	__unsafe_unretained NSString *sumTimeEntries;
	__unsafe_unretained NSString *updatedOn;
} ProjectAttributes;

extern const struct ProjectRelationships {
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *childProjects;
	__unsafe_unretained NSString *issueCategories;
	__unsafe_unretained NSString *issueDrafts;
	__unsafe_unretained NSString *issues;
	__unsafe_unretained NSString *parentProject;
	__unsafe_unretained NSString *trackers;
} ProjectRelationships;

extern const struct ProjectFetchedProperties {
} ProjectFetchedProperties;

@class MembershipItem;
@class Project;
@class IssueCategory;
@class Issue;
@class Issue;
@class Project;
@class Tracker;














@interface ProjectID : NSManagedObjectID {}
@end

@interface _Project : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProjectID*)objectID;





@property (nonatomic, strong) NSDate* createdOn;



//- (BOOL)validateCreatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* easyDueDate;



//- (BOOL)validateEasyDueDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* homepage;



//- (BOOL)validateHomepage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isPublic;



@property BOOL isPublicValue;
- (BOOL)isPublicValue;
- (void)setIsPublicValue:(BOOL)value_;

//- (BOOL)validateIsPublic:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* partialName;



//- (BOOL)validatePartialName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* projectDescription;



//- (BOOL)validateProjectDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* projectIdentifier;



//- (BOOL)validateProjectIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sumEstimatedHours;



@property double sumEstimatedHoursValue;
- (double)sumEstimatedHoursValue;
- (void)setSumEstimatedHoursValue:(double)value_;

//- (BOOL)validateSumEstimatedHours:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sumTimeEntries;



@property double sumTimeEntriesValue;
- (double)sumTimeEntriesValue;
- (void)setSumTimeEntriesValue:(double)value_;

//- (BOOL)validateSumTimeEntries:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedOn;



//- (BOOL)validateUpdatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MembershipItem *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *childProjects;

- (NSMutableSet*)childProjectsSet;




@property (nonatomic, strong) NSSet *issueCategories;

- (NSMutableSet*)issueCategoriesSet;




@property (nonatomic, strong) NSSet *issueDrafts;

- (NSMutableSet*)issueDraftsSet;




@property (nonatomic, strong) NSSet *issues;

- (NSMutableSet*)issuesSet;




@property (nonatomic, strong) Project *parentProject;

//- (BOOL)validateParentProject:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *trackers;

- (NSMutableSet*)trackersSet;





@end

@interface _Project (CoreDataGeneratedAccessors)

- (void)addChildProjects:(NSSet*)value_;
- (void)removeChildProjects:(NSSet*)value_;
- (void)addChildProjectsObject:(Project*)value_;
- (void)removeChildProjectsObject:(Project*)value_;

- (void)addIssueCategories:(NSSet*)value_;
- (void)removeIssueCategories:(NSSet*)value_;
- (void)addIssueCategoriesObject:(IssueCategory*)value_;
- (void)removeIssueCategoriesObject:(IssueCategory*)value_;

- (void)addIssueDrafts:(NSSet*)value_;
- (void)removeIssueDrafts:(NSSet*)value_;
- (void)addIssueDraftsObject:(Issue*)value_;
- (void)removeIssueDraftsObject:(Issue*)value_;

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

- (void)addTrackers:(NSSet*)value_;
- (void)removeTrackers:(NSSet*)value_;
- (void)addTrackersObject:(Tracker*)value_;
- (void)removeTrackersObject:(Tracker*)value_;

@end

@interface _Project (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedOn;
- (void)setPrimitiveCreatedOn:(NSDate*)value;




- (NSDate*)primitiveEasyDueDate;
- (void)setPrimitiveEasyDueDate:(NSDate*)value;




- (NSString*)primitiveHomepage;
- (void)setPrimitiveHomepage:(NSString*)value;




- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSNumber*)primitiveIsPublic;
- (void)setPrimitiveIsPublic:(NSNumber*)value;

- (BOOL)primitiveIsPublicValue;
- (void)setPrimitiveIsPublicValue:(BOOL)value_;




- (NSString*)primitivePartialName;
- (void)setPrimitivePartialName:(NSString*)value;




- (NSString*)primitiveProjectDescription;
- (void)setPrimitiveProjectDescription:(NSString*)value;




- (NSString*)primitiveProjectIdentifier;
- (void)setPrimitiveProjectIdentifier:(NSString*)value;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSNumber*)primitiveSumEstimatedHours;
- (void)setPrimitiveSumEstimatedHours:(NSNumber*)value;

- (double)primitiveSumEstimatedHoursValue;
- (void)setPrimitiveSumEstimatedHoursValue:(double)value_;




- (NSNumber*)primitiveSumTimeEntries;
- (void)setPrimitiveSumTimeEntries:(NSNumber*)value;

- (double)primitiveSumTimeEntriesValue;
- (void)setPrimitiveSumTimeEntriesValue:(double)value_;




- (NSDate*)primitiveUpdatedOn;
- (void)setPrimitiveUpdatedOn:(NSDate*)value;





- (MembershipItem*)primitiveAuthor;
- (void)setPrimitiveAuthor:(MembershipItem*)value;



- (NSMutableSet*)primitiveChildProjects;
- (void)setPrimitiveChildProjects:(NSMutableSet*)value;



- (NSMutableSet*)primitiveIssueCategories;
- (void)setPrimitiveIssueCategories:(NSMutableSet*)value;



- (NSMutableSet*)primitiveIssueDrafts;
- (void)setPrimitiveIssueDrafts:(NSMutableSet*)value;



- (NSMutableSet*)primitiveIssues;
- (void)setPrimitiveIssues:(NSMutableSet*)value;



- (Project*)primitiveParentProject;
- (void)setPrimitiveParentProject:(Project*)value;



- (NSMutableSet*)primitiveTrackers;
- (void)setPrimitiveTrackers:(NSMutableSet*)value;


@end
