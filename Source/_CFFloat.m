// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFFloat.m instead.

#import "_CFFloat.h"

const struct CFFloatAttributes CFFloatAttributes = {
	.value = @"value",
};

const struct CFFloatRelationships CFFloatRelationships = {
};

const struct CFFloatFetchedProperties CFFloatFetchedProperties = {
};

@implementation CFFloatID
@end

@implementation _CFFloat

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFFloat" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFFloat";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFFloat" inManagedObjectContext:moc_];
}

- (CFFloatID*)objectID {
	return (CFFloatID*)[super objectID];
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



- (double)valueValue {
	NSNumber *result = [self value];
	return [result doubleValue];
}

- (void)setValueValue:(double)value_ {
	[self setValue:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result doubleValue];
}

- (void)setPrimitiveValueValue:(double)value_ {
	[self setPrimitiveValue:[NSNumber numberWithDouble:value_]];
}










@end
