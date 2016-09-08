// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Status.h instead.

#import <CoreData/CoreData.h>


extern const struct StatusAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} StatusAttributes;

extern const struct StatusRelationships {
	__unsafe_unretained NSString *issues;
} StatusRelationships;

extern const struct StatusFetchedProperties {
} StatusFetchedProperties;

@class Issue;




@interface StatusID : NSManagedObjectID {}
@end

@interface _Status : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StatusID*)objectID;





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

@interface _Status (CoreDataGeneratedAccessors)

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

@end

@interface _Status (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveIssues;
- (void)setPrimitiveIssues:(NSMutableSet*)value;


@end
