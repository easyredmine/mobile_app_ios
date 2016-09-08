// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFDate.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFDateAttributes {
	__unsafe_unretained NSString *value;
} CFDateAttributes;

extern const struct CFDateRelationships {
} CFDateRelationships;

extern const struct CFDateFetchedProperties {
} CFDateFetchedProperties;




@interface CFDateID : NSManagedObjectID {}
@end

@interface _CFDate : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFDateID*)objectID;





@property (nonatomic, strong) NSDate* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFDate (CoreDataGeneratedAccessors)

@end

@interface _CFDate (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveValue;
- (void)setPrimitiveValue:(NSDate*)value;




@end
