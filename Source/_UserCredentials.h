// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserCredentials.h instead.

#import <CoreData/CoreData.h>


extern const struct UserCredentialsAttributes {
	__unsafe_unretained NSString *baseUrlString;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *username;
} UserCredentialsAttributes;

extern const struct UserCredentialsRelationships {
} UserCredentialsRelationships;

extern const struct UserCredentialsFetchedProperties {
} UserCredentialsFetchedProperties;






@interface UserCredentialsID : NSManagedObjectID {}
@end

@interface _UserCredentials : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserCredentialsID*)objectID;





@property (nonatomic, strong) NSString* baseUrlString;



//- (BOOL)validateBaseUrlString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;






@end

@interface _UserCredentials (CoreDataGeneratedAccessors)

@end

@interface _UserCredentials (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBaseUrlString;
- (void)setPrimitiveBaseUrlString:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;




@end
