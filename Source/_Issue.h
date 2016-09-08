// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.h instead.

#import <CoreData/CoreData.h>


extern const struct IssueAttributes {
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *doneRatio;
	__unsafe_unretained NSString *dueDate;
	__unsafe_unretained NSString *estimatedHours;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *isFavorited;
	__unsafe_unretained NSString *issueDescription;
	__unsafe_unretained NSString *spentHours;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *subject;
	__unsafe_unretained NSString *updatedOn;
} IssueAttributes;

extern const struct IssueRelationships {
	__unsafe_unretained NSString *assignedTo;
	__unsafe_unretained NSString *attachments;
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *children;
	__unsafe_unretained NSString *customFields;
	__unsafe_unretained NSString *fixedVersion;
	__unsafe_unretained NSString *haveRelations;
	__unsafe_unretained NSString *isInRelations;
	__unsafe_unretained NSString *journals;
	__unsafe_unretained NSString *parent;
	__unsafe_unretained NSString *priority;
	__unsafe_unretained NSString *project;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *tracker;
} IssueRelationships;

extern const struct IssueFetchedProperties {
} IssueFetchedProperties;

@class MembershipItem;
@class File;
@class MembershipItem;
@class IssueCategory;
@class Issue;
@class CustomField;
@class Version;
@class Relation;
@class Relation;
@class Journal;
@class Issue;
@class Priority;
@class Project;
@class Status;
@class Tracker;













@interface IssueID : NSManagedObjectID {}
@end

@interface _Issue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IssueID*)objectID;





@property (nonatomic, strong) NSDate* createdOn;



//- (BOOL)validateCreatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* doneRatio;



@property double doneRatioValue;
- (double)doneRatioValue;
- (void)setDoneRatioValue:(double)value_;

//- (BOOL)validateDoneRatio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* dueDate;



//- (BOOL)validateDueDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* estimatedHours;



@property double estimatedHoursValue;
- (double)estimatedHoursValue;
- (void)setEstimatedHoursValue:(double)value_;

//- (BOOL)validateEstimatedHours:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFavorited;



@property BOOL isFavoritedValue;
- (BOOL)isFavoritedValue;
- (void)setIsFavoritedValue:(BOOL)value_;

//- (BOOL)validateIsFavorited:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* issueDescription;



//- (BOOL)validateIssueDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* spentHours;



@property double spentHoursValue;
- (double)spentHoursValue;
- (void)setSpentHoursValue:(double)value_;

//- (BOOL)validateSpentHours:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* subject;



//- (BOOL)validateSubject:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedOn;



//- (BOOL)validateUpdatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MembershipItem *assignedTo;

//- (BOOL)validateAssignedTo:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *attachments;

- (NSMutableSet*)attachmentsSet;




@property (nonatomic, strong) MembershipItem *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) IssueCategory *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *children;

- (NSMutableSet*)childrenSet;




@property (nonatomic, strong) NSSet *customFields;

- (NSMutableSet*)customFieldsSet;




@property (nonatomic, strong) Version *fixedVersion;

//- (BOOL)validateFixedVersion:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *haveRelations;

- (NSMutableSet*)haveRelationsSet;




@property (nonatomic, strong) NSSet *isInRelations;

- (NSMutableSet*)isInRelationsSet;




@property (nonatomic, strong) NSSet *journals;

- (NSMutableSet*)journalsSet;




@property (nonatomic, strong) Issue *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Priority *priority;

//- (BOOL)validatePriority:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Project *project;

//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Status *status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Tracker *tracker;

//- (BOOL)validateTracker:(id*)value_ error:(NSError**)error_;





@end

@interface _Issue (CoreDataGeneratedAccessors)

- (void)addAttachments:(NSSet*)value_;
- (void)removeAttachments:(NSSet*)value_;
- (void)addAttachmentsObject:(File*)value_;
- (void)removeAttachmentsObject:(File*)value_;

- (void)addChildren:(NSSet*)value_;
- (void)removeChildren:(NSSet*)value_;
- (void)addChildrenObject:(Issue*)value_;
- (void)removeChildrenObject:(Issue*)value_;

- (void)addCustomFields:(NSSet*)value_;
- (void)removeCustomFields:(NSSet*)value_;
- (void)addCustomFieldsObject:(CustomField*)value_;
- (void)removeCustomFieldsObject:(CustomField*)value_;

- (void)addHaveRelations:(NSSet*)value_;
- (void)removeHaveRelations:(NSSet*)value_;
- (void)addHaveRelationsObject:(Relation*)value_;
- (void)removeHaveRelationsObject:(Relation*)value_;

- (void)addIsInRelations:(NSSet*)value_;
- (void)removeIsInRelations:(NSSet*)value_;
- (void)addIsInRelationsObject:(Relation*)value_;
- (void)removeIsInRelationsObject:(Relation*)value_;

- (void)addJournals:(NSSet*)value_;
- (void)removeJournals:(NSSet*)value_;
- (void)addJournalsObject:(Journal*)value_;
- (void)removeJournalsObject:(Journal*)value_;

@end

@interface _Issue (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedOn;
- (void)setPrimitiveCreatedOn:(NSDate*)value;




- (NSNumber*)primitiveDoneRatio;
- (void)setPrimitiveDoneRatio:(NSNumber*)value;

- (double)primitiveDoneRatioValue;
- (void)setPrimitiveDoneRatioValue:(double)value_;




- (NSDate*)primitiveDueDate;
- (void)setPrimitiveDueDate:(NSDate*)value;




- (NSNumber*)primitiveEstimatedHours;
- (void)setPrimitiveEstimatedHours:(NSNumber*)value;

- (double)primitiveEstimatedHoursValue;
- (void)setPrimitiveEstimatedHoursValue:(double)value_;




- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSNumber*)primitiveIsFavorited;
- (void)setPrimitiveIsFavorited:(NSNumber*)value;

- (BOOL)primitiveIsFavoritedValue;
- (void)setPrimitiveIsFavoritedValue:(BOOL)value_;




- (NSString*)primitiveIssueDescription;
- (void)setPrimitiveIssueDescription:(NSString*)value;




- (NSNumber*)primitiveSpentHours;
- (void)setPrimitiveSpentHours:(NSNumber*)value;

- (double)primitiveSpentHoursValue;
- (void)setPrimitiveSpentHoursValue:(double)value_;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveSubject;
- (void)setPrimitiveSubject:(NSString*)value;




- (NSDate*)primitiveUpdatedOn;
- (void)setPrimitiveUpdatedOn:(NSDate*)value;





- (MembershipItem*)primitiveAssignedTo;
- (void)setPrimitiveAssignedTo:(MembershipItem*)value;



- (NSMutableSet*)primitiveAttachments;
- (void)setPrimitiveAttachments:(NSMutableSet*)value;



- (MembershipItem*)primitiveAuthor;
- (void)setPrimitiveAuthor:(MembershipItem*)value;



- (IssueCategory*)primitiveCategory;
- (void)setPrimitiveCategory:(IssueCategory*)value;



- (NSMutableSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCustomFields;
- (void)setPrimitiveCustomFields:(NSMutableSet*)value;



- (Version*)primitiveFixedVersion;
- (void)setPrimitiveFixedVersion:(Version*)value;



- (NSMutableSet*)primitiveHaveRelations;
- (void)setPrimitiveHaveRelations:(NSMutableSet*)value;



- (NSMutableSet*)primitiveIsInRelations;
- (void)setPrimitiveIsInRelations:(NSMutableSet*)value;



- (NSMutableSet*)primitiveJournals;
- (void)setPrimitiveJournals:(NSMutableSet*)value;



- (Issue*)primitiveParent;
- (void)setPrimitiveParent:(Issue*)value;



- (Priority*)primitivePriority;
- (void)setPrimitivePriority:(Priority*)value;



- (Project*)primitiveProject;
- (void)setPrimitiveProject:(Project*)value;



- (Status*)primitiveStatus;
- (void)setPrimitiveStatus:(Status*)value;



- (Tracker*)primitiveTracker;
- (void)setPrimitiveTracker:(Tracker*)value;


@end
