// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFEmail.h instead.

#import <CoreData/CoreData.h>
#import "CFString.h"

extern const struct CFEmailAttributes {
} CFEmailAttributes;

extern const struct CFEmailRelationships {
} CFEmailRelationships;

extern const struct CFEmailFetchedProperties {
} CFEmailFetchedProperties;



@interface CFEmailID : NSManagedObjectID {}
@end

@interface _CFEmail : CFString {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFEmailID*)objectID;






@end

@interface _CFEmail (CoreDataGeneratedAccessors)

@end

@interface _CFEmail (CoreDataGeneratedPrimitiveAccessors)


@end
