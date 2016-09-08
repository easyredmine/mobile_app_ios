// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFUser.m instead.

#import "_CFUser.h"

const struct CFUserAttributes CFUserAttributes = {
};

const struct CFUserRelationships CFUserRelationships = {
};

const struct CFUserFetchedProperties CFUserFetchedProperties = {
};

@implementation CFUserID
@end

@implementation _CFUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFUser" inManagedObjectContext:moc_];
}

- (CFUserID*)objectID {
	return (CFUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
