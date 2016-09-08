// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFImmutableString.m instead.

#import "_CFImmutableString.h"

const struct CFImmutableStringAttributes CFImmutableStringAttributes = {
};

const struct CFImmutableStringRelationships CFImmutableStringRelationships = {
};

const struct CFImmutableStringFetchedProperties CFImmutableStringFetchedProperties = {
};

@implementation CFImmutableStringID
@end

@implementation _CFImmutableString

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFImmutableString" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFImmutableString";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFImmutableString" inManagedObjectContext:moc_];
}

- (CFImmutableStringID*)objectID {
	return (CFImmutableStringID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
