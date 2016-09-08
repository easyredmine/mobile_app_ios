// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeEntryActivity.m instead.

#import "_TimeEntryActivity.h"

const struct TimeEntryActivityAttributes TimeEntryActivityAttributes = {
	.identifier = @"identifier",
	.isDefault = @"isDefault",
	.name = @"name",
};

const struct TimeEntryActivityRelationships TimeEntryActivityRelationships = {
};

const struct TimeEntryActivityFetchedProperties TimeEntryActivityFetchedProperties = {
};

@implementation TimeEntryActivityID
@end

@implementation _TimeEntryActivity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TimeEntryActivity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TimeEntryActivity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TimeEntryActivity" inManagedObjectContext:moc_];
}

- (TimeEntryActivityID*)objectID {
	return (TimeEntryActivityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isDefaultValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDefault"];
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





@dynamic isDefault;



- (BOOL)isDefaultValue {
	NSNumber *result = [self isDefault];
	return [result boolValue];
}

- (void)setIsDefaultValue:(BOOL)value_ {
	[self setIsDefault:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDefaultValue {
	NSNumber *result = [self primitiveIsDefault];
	return [result boolValue];
}

- (void)setPrimitiveIsDefaultValue:(BOOL)value_ {
	[self setPrimitiveIsDefault:[NSNumber numberWithBool:value_]];
}





@dynamic name;











@end
