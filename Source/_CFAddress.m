// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFAddress.m instead.

#import "_CFAddress.h"

const struct CFAddressAttributes CFAddressAttributes = {
};

const struct CFAddressRelationships CFAddressRelationships = {
};

const struct CFAddressFetchedProperties CFAddressFetchedProperties = {
};

@implementation CFAddressID
@end

@implementation _CFAddress

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFAddress" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFAddress";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFAddress" inManagedObjectContext:moc_];
}

- (CFAddressID*)objectID {
	return (CFAddressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
