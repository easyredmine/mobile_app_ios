// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFPercent.m instead.

#import "_CFPercent.h"

const struct CFPercentAttributes CFPercentAttributes = {
};

const struct CFPercentRelationships CFPercentRelationships = {
};

const struct CFPercentFetchedProperties CFPercentFetchedProperties = {
};

@implementation CFPercentID
@end

@implementation _CFPercent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFPercent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFPercent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFPercent" inManagedObjectContext:moc_];
}

- (CFPercentID*)objectID {
	return (CFPercentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
