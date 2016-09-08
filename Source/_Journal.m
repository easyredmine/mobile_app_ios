// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Journal.m instead.

#import "_Journal.h"

const struct JournalAttributes JournalAttributes = {
	.createdOn = @"createdOn",
	.identifier = @"identifier",
	.notes = @"notes",
};

const struct JournalRelationships JournalRelationships = {
	.issue = @"issue",
	.user = @"user",
};

const struct JournalFetchedProperties JournalFetchedProperties = {
};

@implementation JournalID
@end

@implementation _Journal

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Journal" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Journal";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Journal" inManagedObjectContext:moc_];
}

- (JournalID*)objectID {
	return (JournalID*)[super objectID];
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




@dynamic createdOn;






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





@dynamic notes;






@dynamic issue;

	

@dynamic user;

	






@end
