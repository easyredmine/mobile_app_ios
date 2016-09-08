// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Relation.h instead.

#import <CoreData/CoreData.h>


extern const struct RelationAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *relationType;
} RelationAttributes;

extern const struct RelationRelationships {
	__unsafe_unretained NSString *issue;
	__unsafe_unretained NSString *issueTo;
} RelationRelationships;

extern const struct RelationFetchedProperties {
} RelationFetchedProperties;

@class Issue;
@class Issue;




@interface RelationID : NSManagedObjectID {}
@end

@interface _Relation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RelationID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* relationType;



//- (BOOL)validateRelationType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Issue *issue;

//- (BOOL)validateIssue:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Issue *issueTo;

//- (BOOL)validateIssueTo:(id*)value_ error:(NSError**)error_;





@end

@interface _Relation (CoreDataGeneratedAccessors)

@end

@interface _Relation (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveRelationType;
- (void)setPrimitiveRelationType:(NSString*)value;





- (Issue*)primitiveIssue;
- (void)setPrimitiveIssue:(Issue*)value;



- (Issue*)primitiveIssueTo;
- (void)setPrimitiveIssueTo:(Issue*)value;


@end
