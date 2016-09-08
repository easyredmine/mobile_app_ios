// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomField.m instead.

#import "_CustomField.h"

const struct CustomFieldAttributes CustomFieldAttributes = {
	.fieldFormat = @"fieldFormat",
	.identifier = @"identifier",
	.internalName = @"internalName",
	.name = @"name",
};

const struct CustomFieldRelationships CustomFieldRelationships = {
	.issues = @"issues",
};

const struct CustomFieldFetchedProperties CustomFieldFetchedProperties = {
};

@implementation CustomFieldID
@end

@implementation _CustomField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CustomField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CustomField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CustomField" inManagedObjectContext:moc_];
}

- (CustomFieldID*)objectID {
	return (CustomFieldID*)[super objectID];
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




@dynamic fieldFormat;






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





@dynamic internalName;






@dynamic name;






@dynamic issues;

	
- (NSMutableSet*)issuesSet {
	[self willAccessValueForKey:@"issues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"issues"];
  
	[self didAccessValueForKey:@"issues"];
	return result;
}
	






@end
