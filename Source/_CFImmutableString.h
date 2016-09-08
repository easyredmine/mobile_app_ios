// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFImmutableString.h instead.

#import <CoreData/CoreData.h>
#import "CFString.h"

extern const struct CFImmutableStringAttributes {
} CFImmutableStringAttributes;

extern const struct CFImmutableStringRelationships {
} CFImmutableStringRelationships;

extern const struct CFImmutableStringFetchedProperties {
} CFImmutableStringFetchedProperties;



@interface CFImmutableStringID : NSManagedObjectID {}
@end

@interface _CFImmutableString : CFString {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFImmutableStringID*)objectID;






@end

@interface _CFImmutableString (CoreDataGeneratedAccessors)

@end

@interface _CFImmutableString (CoreDataGeneratedPrimitiveAccessors)


@end
