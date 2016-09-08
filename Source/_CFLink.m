// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFLink.m instead.

#import "_CFLink.h"

const struct CFLinkAttributes CFLinkAttributes = {
};

const struct CFLinkRelationships CFLinkRelationships = {
};

const struct CFLinkFetchedProperties CFLinkFetchedProperties = {
};

@implementation CFLinkID
@end

@implementation _CFLink

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFLink" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFLink";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFLink" inManagedObjectContext:moc_];
}

- (CFLinkID*)objectID {
	return (CFLinkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
