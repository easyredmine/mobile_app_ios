// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFRating.m instead.

#import "_CFRating.h"

const struct CFRatingAttributes CFRatingAttributes = {
};

const struct CFRatingRelationships CFRatingRelationships = {
};

const struct CFRatingFetchedProperties CFRatingFetchedProperties = {
};

@implementation CFRatingID
@end

@implementation _CFRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFRating" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFRating";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFRating" inManagedObjectContext:moc_];
}

- (CFRatingID*)objectID {
	return (CFRatingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
