// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Query.m instead.

#import "_Query.h"

const struct QueryAttributes QueryAttributes = {
	.identifier = @"identifier",
	.isEnable = @"isEnable",
	.isPublic = @"isPublic",
	.name = @"name",
	.type = @"type",
};

const struct QueryRelationships QueryRelationships = {
};

const struct QueryFetchedProperties QueryFetchedProperties = {
};

@implementation QueryID
@end

@implementation _Query

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Query" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Query";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Query" inManagedObjectContext:moc_];
}

- (QueryID*)objectID {
	return (QueryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isEnableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isEnable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPublicValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPublic"];
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





@dynamic isEnable;



- (BOOL)isEnableValue {
	NSNumber *result = [self isEnable];
	return [result boolValue];
}

- (void)setIsEnableValue:(BOOL)value_ {
	[self setIsEnable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsEnableValue {
	NSNumber *result = [self primitiveIsEnable];
	return [result boolValue];
}

- (void)setPrimitiveIsEnableValue:(BOOL)value_ {
	[self setPrimitiveIsEnable:[NSNumber numberWithBool:value_]];
}





@dynamic isPublic;



- (BOOL)isPublicValue {
	NSNumber *result = [self isPublic];
	return [result boolValue];
}

- (void)setIsPublicValue:(BOOL)value_ {
	[self setIsPublic:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsPublicValue {
	NSNumber *result = [self primitiveIsPublic];
	return [result boolValue];
}

- (void)setPrimitiveIsPublicValue:(BOOL)value_ {
	[self setPrimitiveIsPublic:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic type;











@end
