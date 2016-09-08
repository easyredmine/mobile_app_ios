// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFBool.m instead.

#import "_CFBool.h"

const struct CFBoolAttributes CFBoolAttributes = {
	.value = @"value",
};

const struct CFBoolRelationships CFBoolRelationships = {
};

const struct CFBoolFetchedProperties CFBoolFetchedProperties = {
};

@implementation CFBoolID
@end

@implementation _CFBool

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFBool" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFBool";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFBool" inManagedObjectContext:moc_];
}

- (CFBoolID*)objectID {
	return (CFBoolID*)[super objectID];
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



- (BOOL)valueValue {
	NSNumber *result = [self value];
	return [result boolValue];
}

- (void)setValueValue:(BOOL)value_ {
	[self setValue:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result boolValue];
}

- (void)setPrimitiveValueValue:(BOOL)value_ {
	[self setPrimitiveValue:[NSNumber numberWithBool:value_]];
}










@end
