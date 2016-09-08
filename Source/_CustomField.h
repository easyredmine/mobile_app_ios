// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomField.h instead.

#import <CoreData/CoreData.h>


extern const struct CustomFieldAttributes {
	__unsafe_unretained NSString *fieldFormat;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *internalName;
	__unsafe_unretained NSString *name;
} CustomFieldAttributes;

extern const struct CustomFieldRelationships {
	__unsafe_unretained NSString *issues;
} CustomFieldRelationships;

extern const struct CustomFieldFetchedProperties {
} CustomFieldFetchedProperties;

@class Issue;






@interface CustomFieldID : NSManagedObjectID {}
@end

@interface _CustomField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CustomFieldID*)objectID;





@property (nonatomic, strong) NSString* fieldFormat;



//- (BOOL)validateFieldFormat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* internalName;



//- (BOOL)validateInternalName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *issues;

- (NSMutableSet*)issuesSet;





@end

@interface _CustomField (CoreDataGeneratedAccessors)

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

@end

@interface _CustomField (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFieldFormat;
- (void)setPrimitiveFieldFormat:(NSString*)value;




- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveInternalName;
- (void)setPrimitiveInternalName:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveIssues;
- (void)setPrimitiveIssues:(NSMutableSet*)value;


@end
