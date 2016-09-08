// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Relation.m instead.

#import "_Relation.h"

const struct RelationAttributes RelationAttributes = {
	.identifier = @"identifier",
	.relationType = @"relationType",
};

const struct RelationRelationships RelationRelationships = {
	.issue = @"issue",
	.issueTo = @"issueTo",
};

const struct RelationFetchedProperties RelationFetchedProperties = {
};

@implementation RelationID
@end

@implementation _Relation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Relation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Relation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Relation" inManagedObjectContext:moc_];
}

- (RelationID*)objectID {
	return (RelationID*)[super objectID];
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





@dynamic relationType;






@dynamic issue;

	

@dynamic issueTo;

	






@end
