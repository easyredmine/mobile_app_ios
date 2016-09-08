// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IssueCategory.m instead.

#import "_IssueCategory.h"

const struct IssueCategoryAttributes IssueCategoryAttributes = {
	.identifier = @"identifier",
	.name = @"name",
};

const struct IssueCategoryRelationships IssueCategoryRelationships = {
	.issues = @"issues",
	.project = @"project",
};

const struct IssueCategoryFetchedProperties IssueCategoryFetchedProperties = {
};

@implementation IssueCategoryID
@end

@implementation _IssueCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"IssueCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"IssueCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"IssueCategory" inManagedObjectContext:moc_];
}

- (IssueCategoryID*)objectID {
	return (IssueCategoryID*)[super objectID];
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

	

@dynamic project;

	






@end
