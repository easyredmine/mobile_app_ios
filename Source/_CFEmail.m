// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFEmail.m instead.

#import "_CFEmail.h"

const struct CFEmailAttributes CFEmailAttributes = {
};

const struct CFEmailRelationships CFEmailRelationships = {
};

const struct CFEmailFetchedProperties CFEmailFetchedProperties = {
};

@implementation CFEmailID
@end

@implementation _CFEmail

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFEmail" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFEmail";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFEmail" inManagedObjectContext:moc_];
}

- (CFEmailID*)objectID {
	return (CFEmailID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
