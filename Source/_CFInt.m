// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFInt.m instead.

#import "_CFInt.h"

const struct CFIntAttributes CFIntAttributes = {
	.value = @"value",
};

const struct CFIntRelationships CFIntRelationships = {
};

const struct CFIntFetchedProperties CFIntFetchedProperties = {
};

@implementation CFIntID
@end

@implementation _CFInt

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFInt" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFInt";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFInt" inManagedObjectContext:moc_];
}

- (CFIntID*)objectID {
	return (CFIntID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic value;



- (int64_t)valueValue {
	NSNumber *result = [self value];
	return [result longLongValue];
}

- (void)setValueValue:(int64_t)value_ {
	[self setValue:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result longLongValue];
}

- (void)setPrimitiveValueValue:(int64_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithLongLong:value_]];
}










@end
