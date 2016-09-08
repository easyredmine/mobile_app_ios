// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MembershipItem.m instead.

#import "_MembershipItem.h"

const struct MembershipItemAttributes MembershipItemAttributes = {
	.identifier = @"identifier",
	.name = @"name",
};

const struct MembershipItemRelationships MembershipItemRelationships = {
	.assignedIssues = @"assignedIssues",
	.authorJournals = @"authorJournals",
	.authoredIssues = @"authoredIssues",
	.avatarUrls = @"avatarUrls",
	.projects = @"projects",
};

const struct MembershipItemFetchedProperties MembershipItemFetchedProperties = {
};

@implementation MembershipItemID
@end

@implementation _MembershipItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MembershipItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MembershipItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MembershipItem" inManagedObjectContext:moc_];
}

- (MembershipItemID*)objectID {
	return (MembershipItemID*)[super objectID];
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






@dynamic assignedIssues;

	
- (NSMutableSet*)assignedIssuesSet {
	[self willAccessValueForKey:@"assignedIssues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"assignedIssues"];
  
	[self didAccessValueForKey:@"assignedIssues"];
	return result;
}
	

@dynamic authorJournals;

	
- (NSMutableSet*)authorJournalsSet {
	[self willAccessValueForKey:@"authorJournals"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"authorJournals"];
  
	[self didAccessValueForKey:@"authorJournals"];
	return result;
}
	

@dynamic authoredIssues;

	
- (NSMutableSet*)authoredIssuesSet {
	[self willAccessValueForKey:@"authoredIssues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"authoredIssues"];
  
	[self didAccessValueForKey:@"authoredIssues"];
	return result;
}
	

@dynamic avatarUrls;

	

@dynamic projects;

	
- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];
  
	[self didAccessValueForKey:@"projects"];
	return result;
}
	






@end
