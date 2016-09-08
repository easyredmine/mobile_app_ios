// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFDate.m instead.

#import "_CFDate.h"

const struct CFDateAttributes CFDateAttributes = {
	.value = @"value",
};

const struct CFDateRelationships CFDateRelationships = {
};

const struct CFDateFetchedProperties CFDateFetchedProperties = {
};

@implementation CFDateID
@end

@implementation _CFDate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFDate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFDate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFDate" inManagedObjectContext:moc_];
}

- (CFDateID*)objectID {
	return (CFDateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic value;











@end
