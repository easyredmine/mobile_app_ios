// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFUser.h instead.

#import <CoreData/CoreData.h>
#import "CFList.h"

extern const struct CFUserAttributes {
} CFUserAttributes;

extern const struct CFUserRelationships {
} CFUserRelationships;

extern const struct CFUserFetchedProperties {
} CFUserFetchedProperties;



@interface CFUserID : NSManagedObjectID {}
@end

@interface _CFUser : CFList {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFUserID*)objectID;






@end

@interface _CFUser (CoreDataGeneratedAccessors)

@end

@interface _CFUser (CoreDataGeneratedPrimitiveAccessors)


@end
