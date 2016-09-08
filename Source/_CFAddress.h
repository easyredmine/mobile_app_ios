// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFAddress.h instead.

#import <CoreData/CoreData.h>
#import "CFString.h"

extern const struct CFAddressAttributes {
} CFAddressAttributes;

extern const struct CFAddressRelationships {
} CFAddressRelationships;

extern const struct CFAddressFetchedProperties {
} CFAddressFetchedProperties;



@interface CFAddressID : NSManagedObjectID {}
@end

@interface _CFAddress : CFString {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFAddressID*)objectID;






@end

@interface _CFAddress (CoreDataGeneratedAccessors)

@end

@interface _CFAddress (CoreDataGeneratedPrimitiveAccessors)


@end
