// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFLink.h instead.

#import <CoreData/CoreData.h>
#import "CFString.h"

extern const struct CFLinkAttributes {
} CFLinkAttributes;

extern const struct CFLinkRelationships {
} CFLinkRelationships;

extern const struct CFLinkFetchedProperties {
} CFLinkFetchedProperties;



@interface CFLinkID : NSManagedObjectID {}
@end

@interface _CFLink : CFString {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFLinkID*)objectID;






@end

@interface _CFLink (CoreDataGeneratedAccessors)

@end

@interface _CFLink (CoreDataGeneratedPrimitiveAccessors)


@end
