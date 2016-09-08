// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AvatarUrls.h instead.

#import <CoreData/CoreData.h>


extern const struct AvatarUrlsAttributes {
	__unsafe_unretained NSString *large;
	__unsafe_unretained NSString *medium;
	__unsafe_unretained NSString *original;
	__unsafe_unretained NSString *small;
} AvatarUrlsAttributes;

extern const struct AvatarUrlsRelationships {
	__unsafe_unretained NSString *assignedTo;
} AvatarUrlsRelationships;

extern const struct AvatarUrlsFetchedProperties {
} AvatarUrlsFetchedProperties;

@class MembershipItem;






@interface AvatarUrlsID : NSManagedObjectID {}
@end

@interface _AvatarUrls : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AvatarUrlsID*)objectID;





@property (nonatomic, strong) NSString* large;



//- (BOOL)validateLarge:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* medium;



//- (BOOL)validateMedium:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* original;



//- (BOOL)validateOriginal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* small;



//- (BOOL)validateSmall:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MembershipItem *assignedTo;

//- (BOOL)validateAssignedTo:(id*)value_ error:(NSError**)error_;





@end

@interface _AvatarUrls (CoreDataGeneratedAccessors)

@end

@interface _AvatarUrls (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveLarge;
- (void)setPrimitiveLarge:(NSString*)value;




- (NSString*)primitiveMedium;
- (void)setPrimitiveMedium:(NSString*)value;




- (NSString*)primitiveOriginal;
- (void)setPrimitiveOriginal:(NSString*)value;




- (NSString*)primitiveSmall;
- (void)setPrimitiveSmall:(NSString*)value;





- (MembershipItem*)primitiveAssignedTo;
- (void)setPrimitiveAssignedTo:(MembershipItem*)value;


@end
