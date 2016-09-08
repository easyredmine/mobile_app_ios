// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AvatarUrls.m instead.

#import "_AvatarUrls.h"

const struct AvatarUrlsAttributes AvatarUrlsAttributes = {
	.large = @"large",
	.medium = @"medium",
	.original = @"original",
	.small = @"small",
};

const struct AvatarUrlsRelationships AvatarUrlsRelationships = {
	.assignedTo = @"assignedTo",
};

const struct AvatarUrlsFetchedProperties AvatarUrlsFetchedProperties = {
};

@implementation AvatarUrlsID
@end

@implementation _AvatarUrls

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AvatarUrls" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AvatarUrls";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AvatarUrls" inManagedObjectContext:moc_];
}

- (AvatarUrlsID*)objectID {
	return (AvatarUrlsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic large;






@dynamic medium;






@dynamic original;






@dynamic small;






@dynamic assignedTo;

	






@end
