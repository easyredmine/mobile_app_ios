// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MembershipItem.h instead.

#import <CoreData/CoreData.h>


extern const struct MembershipItemAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} MembershipItemAttributes;

extern const struct MembershipItemRelationships {
	__unsafe_unretained NSString *assignedIssues;
	__unsafe_unretained NSString *authorJournals;
	__unsafe_unretained NSString *authoredIssues;
	__unsafe_unretained NSString *avatarUrls;
	__unsafe_unretained NSString *projects;
} MembershipItemRelationships;

extern const struct MembershipItemFetchedProperties {
} MembershipItemFetchedProperties;

@class Issue;
@class Journal;
@class Issue;
@class AvatarUrls;
@class Project;




@interface MembershipItemID : NSManagedObjectID {}
@end

@interface _MembershipItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MembershipItemID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *assignedIssues;

- (NSMutableSet*)assignedIssuesSet;




@property (nonatomic, strong) NSSet *authorJournals;

- (NSMutableSet*)authorJournalsSet;




@property (nonatomic, strong) NSSet *authoredIssues;

- (NSMutableSet*)authoredIssuesSet;




@property (nonatomic, strong) AvatarUrls *avatarUrls;

//- (BOOL)validateAvatarUrls:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *projects;

- (NSMutableSet*)projectsSet;





@end

@interface _MembershipItem (CoreDataGeneratedAccessors)

- (void)addAssignedIssues:(NSSet*)value_;
- (void)removeAssignedIssues:(NSSet*)value_;
- (void)addAssignedIssuesObject:(Issue*)value_;
- (void)removeAssignedIssuesObject:(Issue*)value_;

- (void)addAuthorJournals:(NSSet*)value_;
- (void)removeAuthorJournals:(NSSet*)value_;
- (void)addAuthorJournalsObject:(Journal*)value_;
- (void)removeAuthorJournalsObject:(Journal*)value_;

- (void)addAuthoredIssues:(NSSet*)value_;
- (void)removeAuthoredIssues:(NSSet*)value_;
- (void)addAuthoredIssuesObject:(Issue*)value_;
- (void)removeAuthoredIssuesObject:(Issue*)value_;

- (void)addProjects:(NSSet*)value_;
- (void)removeProjects:(NSSet*)value_;
- (void)addProjectsObject:(Project*)value_;
- (void)removeProjectsObject:(Project*)value_;

@end

@interface _MembershipItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveAssignedIssues;
- (void)setPrimitiveAssignedIssues:(NSMutableSet*)value;



- (NSMutableSet*)primitiveAuthorJournals;
- (void)setPrimitiveAuthorJournals:(NSMutableSet*)value;



- (NSMutableSet*)primitiveAuthoredIssues;
- (void)setPrimitiveAuthoredIssues:(NSMutableSet*)value;



- (AvatarUrls*)primitiveAvatarUrls;
- (void)setPrimitiveAvatarUrls:(AvatarUrls*)value;



- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;


@end
