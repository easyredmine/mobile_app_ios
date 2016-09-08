// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFFloat.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFFloatAttributes {
	__unsafe_unretained NSString *value;
} CFFloatAttributes;

extern const struct CFFloatRelationships {
} CFFloatRelationships;

extern const struct CFFloatFetchedProperties {
} CFFloatFetchedProperties;




@interface CFFloatID : NSManagedObjectID {}
@end

@interface _CFFloat : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFFloatID*)objectID;





@property (nonatomic, strong) NSNumber* value;



@property double valueValue;
- (double)valueValue;
- (void)setValueValue:(double)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFFloat (CoreDataGeneratedAccessors)

@end

@interface _CFFloat (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (double)primitiveValueValue;
- (void)setPrimitiveValueValue:(double)value_;




@end
