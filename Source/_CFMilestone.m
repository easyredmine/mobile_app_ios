// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFMilestone.m instead.

#import "_CFMilestone.h"

const struct CFMilestoneAttributes CFMilestoneAttributes = {
};

const struct CFMilestoneRelationships CFMilestoneRelationships = {
};

const struct CFMilestoneFetchedProperties CFMilestoneFetchedProperties = {
};

@implementation CFMilestoneID
@end

@implementation _CFMilestone

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFMilestone" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFMilestone";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFMilestone" inManagedObjectContext:moc_];
}

- (CFMilestoneID*)objectID {
	return (CFMilestoneID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
