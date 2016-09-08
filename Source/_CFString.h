// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFString.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFStringAttributes {
	__unsafe_unretained NSString *value;
} CFStringAttributes;

extern const struct CFStringRelationships {
} CFStringRelationships;

extern const struct CFStringFetchedProperties {
} CFStringFetchedProperties;




@interface CFStringID : NSManagedObjectID {}
@end

@interface _CFString : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFStringID*)objectID;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFString (CoreDataGeneratedAccessors)

@end

@interface _CFString (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;




@end
