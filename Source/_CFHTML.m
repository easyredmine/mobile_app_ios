// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFHTML.m instead.

#import "_CFHTML.h"

const struct CFHTMLAttributes CFHTMLAttributes = {
};

const struct CFHTMLRelationships CFHTMLRelationships = {
};

const struct CFHTMLFetchedProperties CFHTMLFetchedProperties = {
};

@implementation CFHTMLID
@end

@implementation _CFHTML

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFHTML" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFHTML";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFHTML" inManagedObjectContext:moc_];
}

- (CFHTMLID*)objectID {
	return (CFHTMLID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
