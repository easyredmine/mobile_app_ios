// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Query.h instead.

#import <CoreData/CoreData.h>


extern const struct QueryAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *isEnable;
	__unsafe_unretained NSString *isPublic;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *type;
} QueryAttributes;

extern const struct QueryRelationships {
} QueryRelationships;

extern const struct QueryFetchedProperties {
} QueryFetchedProperties;








@interface QueryID : NSManagedObjectID {}
@end

@interface _Query : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (QueryID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isEnable;



@property BOOL isEnableValue;
- (BOOL)isEnableValue;
- (void)setIsEnableValue:(BOOL)value_;

//- (BOOL)validateIsEnable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isPublic;



@property BOOL isPublicValue;
- (BOOL)isPublicValue;
- (void)setIsPublicValue:(BOOL)value_;

//- (BOOL)validateIsPublic:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;






@end

@interface _Query (CoreDataGeneratedAccessors)

@end

@interface _Query (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSNumber*)primitiveIsEnable;
- (void)setPrimitiveIsEnable:(NSNumber*)value;

- (BOOL)primitiveIsEnableValue;
- (void)setPrimitiveIsEnableValue:(BOOL)value_;




- (NSNumber*)primitiveIsPublic;
- (void)setPrimitiveIsPublic:(NSNumber*)value;

- (BOOL)primitiveIsPublicValue;
- (void)setPrimitiveIsPublicValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




@end
