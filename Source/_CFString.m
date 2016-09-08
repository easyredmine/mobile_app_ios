// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFString.m instead.

#import "_CFString.h"

const struct CFStringAttributes CFStringAttributes = {
	.value = @"value",
};

const struct CFStringRelationships CFStringRelationships = {
};

const struct CFStringFetchedProperties CFStringFetchedProperties = {
};

@implementation CFStringID
@end

@implementation _CFString

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFString" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFString";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFString" inManagedObjectContext:moc_];
}

- (CFStringID*)objectID {
	return (CFStringID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic value;











@end
