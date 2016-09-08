// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tracker.m instead.

#import "_Tracker.h"

const struct TrackerAttributes TrackerAttributes = {
	.identifier = @"identifier",
	.name = @"name",
};

const struct TrackerRelationships TrackerRelationships = {
	.issues = @"issues",
	.projects = @"projects",
};

const struct TrackerFetchedProperties TrackerFetchedProperties = {
};

@implementation TrackerID
@end

@implementation _Tracker

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tracker" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tracker";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tracker" inManagedObjectContext:moc_];
}

- (TrackerID*)objectID {
	return (TrackerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic identifier;



- (int32_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result intValue];
}

- (void)setIdentifierValue:(int32_t)value_ {
	[self setIdentifier:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result intValue];
}

- (void)setPrimitiveIdentifierValue:(int32_t)value_ {
	[self setPrimitiveIdentifier:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic issues;

	
- (NSMutableSet*)issuesSet {
	[self willAccessValueForKey:@"issues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"issues"];
  
	[self didAccessValueForKey:@"issues"];
	return result;
}
	

@dynamic projects;

	
- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];
  
	[self didAccessValueForKey:@"projects"];
	return result;
}
	






@end
