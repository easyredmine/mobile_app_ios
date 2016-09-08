// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFInt.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFIntAttributes {
	__unsafe_unretained NSString *value;
} CFIntAttributes;

extern const struct CFIntRelationships {
} CFIntRelationships;

extern const struct CFIntFetchedProperties {
} CFIntFetchedProperties;




@interface CFIntID : NSManagedObjectID {}
@end

@interface _CFInt : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFIntID*)objectID;





@property (nonatomic, strong) NSNumber* value;



@property int64_t valueValue;
- (int64_t)valueValue;
- (void)setValueValue:(int64_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFInt (CoreDataGeneratedAccessors)

@end

@interface _CFInt (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int64_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int64_t)value_;




@end
