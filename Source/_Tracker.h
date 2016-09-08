// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tracker.h instead.

#import <CoreData/CoreData.h>


extern const struct TrackerAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} TrackerAttributes;

extern const struct TrackerRelationships {
	__unsafe_unretained NSString *issues;
	__unsafe_unretained NSString *projects;
} TrackerRelationships;

extern const struct TrackerFetchedProperties {
} TrackerFetchedProperties;

@class Issue;
@class Project;




@interface TrackerID : NSManagedObjectID {}
@end

@interface _Tracker : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TrackerID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *issues;

- (NSMutableSet*)issuesSet;




@property (nonatomic, strong) NSSet *projects;

- (NSMutableSet*)projectsSet;





@end

@interface _Tracker (CoreDataGeneratedAccessors)

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

- (void)addProjects:(NSSet*)value_;
- (void)removeProjects:(NSSet*)value_;
- (void)addProjectsObject:(Project*)value_;
- (void)removeProjectsObject:(Project*)value_;

@end

@interface _Tracker (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveIssues;
- (void)setPrimitiveIssues:(NSMutableSet*)value;



- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;


@end
