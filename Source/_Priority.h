// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Priority.h instead.

#import <CoreData/CoreData.h>


extern const struct PriorityAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} PriorityAttributes;

extern const struct PriorityRelationships {
	__unsafe_unretained NSString *issues;
} PriorityRelationships;

extern const struct PriorityFetchedProperties {
} PriorityFetchedProperties;

@class Issue;




@interface PriorityID : NSManagedObjectID {}
@end

@interface _Priority : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PriorityID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *issues;

- (NSMutableSet*)issuesSet;





@end

@interface _Priority (CoreDataGeneratedAccessors)

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

@end

@interface _Priority (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveIssues;
- (void)setPrimitiveIssues:(NSMutableSet*)value;


@end
