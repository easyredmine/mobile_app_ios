// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFList.m instead.

#import "_CFList.h"

const struct CFListAttributes CFListAttributes = {
	.multiple = @"multiple",
	.value = @"value",
};

const struct CFListRelationships CFListRelationships = {
};

const struct CFListFetchedProperties CFListFetchedProperties = {
};

@implementation CFListID
@end

@implementation _CFList

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CFList" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CFList";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CFList" inManagedObjectContext:moc_];
}

- (CFListID*)objectID {
	return (CFListID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"multipleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"multiple"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic multiple;



- (BOOL)multipleValue {
	NSNumber *result = [self multiple];
	return [result boolValue];
}

- (void)setMultipleValue:(BOOL)value_ {
	[self setMultiple:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMultipleValue {
	NSNumber *result = [self primitiveMultiple];
	return [result boolValue];
}

- (void)setPrimitiveMultipleValue:(BOOL)value_ {
	[self setPrimitiveMultiple:[NSNumber numberWithBool:value_]];
}





@dynamic value;











@end
