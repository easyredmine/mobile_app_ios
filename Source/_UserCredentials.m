// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserCredentials.m instead.

#import "_UserCredentials.h"

const struct UserCredentialsAttributes UserCredentialsAttributes = {
	.baseUrlString = @"baseUrlString",
	.password = @"password",
	.username = @"username",
};

const struct UserCredentialsRelationships UserCredentialsRelationships = {
};

const struct UserCredentialsFetchedProperties UserCredentialsFetchedProperties = {
};

@implementation UserCredentialsID
@end

@implementation _UserCredentials

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserCredentials" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserCredentials";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserCredentials" inManagedObjectContext:moc_];
}

- (UserCredentialsID*)objectID {
	return (UserCredentialsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic baseUrlString;






@dynamic password;






@dynamic username;











@end
