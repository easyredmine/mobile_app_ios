// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFBool.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFBoolAttributes {
	__unsafe_unretained NSString *value;
} CFBoolAttributes;

extern const struct CFBoolRelationships {
} CFBoolRelationships;

extern const struct CFBoolFetchedProperties {
} CFBoolFetchedProperties;




@interface CFBoolID : NSManagedObjectID {}
@end

@interface _CFBool : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFBoolID*)objectID;





@property (nonatomic, strong) NSNumber* value;



@property BOOL valueValue;
- (BOOL)valueValue;
- (void)setValueValue:(BOOL)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFBool (CoreDataGeneratedAccessors)

@end

@interface _CFBool (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (BOOL)primitiveValueValue;
- (void)setPrimitiveValueValue:(BOOL)value_;




@end
