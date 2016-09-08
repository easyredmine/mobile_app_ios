// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IssueCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct IssueCategoryAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} IssueCategoryAttributes;

extern const struct IssueCategoryRelationships {
	__unsafe_unretained NSString *issues;
	__unsafe_unretained NSString *project;
} IssueCategoryRelationships;

extern const struct IssueCategoryFetchedProperties {
} IssueCategoryFetchedProperties;

@class Issue;
@class Project;




@interface IssueCategoryID : NSManagedObjectID {}
@end

@interface _IssueCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IssueCategoryID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Issue *issues;

//- (BOOL)validateIssues:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Project *project;

//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;





@end

@interface _IssueCategory (CoreDataGeneratedAccessors)

@end

@interface _IssueCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Issue*)primitiveIssues;
- (void)setPrimitiveIssues:(Issue*)value;



- (Project*)primitiveProject;
- (void)setPrimitiveProject:(Project*)value;


@end
