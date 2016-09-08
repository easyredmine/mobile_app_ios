// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeEntryActivity.h instead.

#import <CoreData/CoreData.h>


extern const struct TimeEntryActivityAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *isDefault;
	__unsafe_unretained NSString *name;
} TimeEntryActivityAttributes;

extern const struct TimeEntryActivityRelationships {
} TimeEntryActivityRelationships;

extern const struct TimeEntryActivityFetchedProperties {
} TimeEntryActivityFetchedProperties;






@interface TimeEntryActivityID : NSManagedObjectID {}
@end

@interface _TimeEntryActivity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TimeEntryActivityID*)objectID;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isDefault;



@property BOOL isDefaultValue;
- (BOOL)isDefaultValue;
- (void)setIsDefaultValue:(BOOL)value_;

//- (BOOL)validateIsDefault:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _TimeEntryActivity (CoreDataGeneratedAccessors)

@end

@interface _TimeEntryActivity (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSNumber*)primitiveIsDefault;
- (void)setPrimitiveIsDefault:(NSNumber*)value;

- (BOOL)primitiveIsDefaultValue;
- (void)setPrimitiveIsDefaultValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
