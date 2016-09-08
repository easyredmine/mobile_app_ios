// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.m instead.

#import "_Project.h"

const struct ProjectAttributes ProjectAttributes = {
	.createdOn = @"createdOn",
	.easyDueDate = @"easyDueDate",
	.homepage = @"homepage",
	.identifier = @"identifier",
	.isPublic = @"isPublic",
	.partialName = @"partialName",
	.projectDescription = @"projectDescription",
	.projectIdentifier = @"projectIdentifier",
	.status = @"status",
	.sumEstimatedHours = @"sumEstimatedHours",
	.sumTimeEntries = @"sumTimeEntries",
	.updatedOn = @"updatedOn",
};

const struct ProjectRelationships ProjectRelationships = {
	.author = @"author",
	.childProjects = @"childProjects",
	.issueCategories = @"issueCategories",
	.issueDrafts = @"issueDrafts",
	.issues = @"issues",
	.parentProject = @"parentProject",
	.trackers = @"trackers",
};

const struct ProjectFetchedProperties ProjectFetchedProperties = {
};

@implementation ProjectID
@end

@implementation _Project

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Project";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:moc_];
}

- (ProjectID*)objectID {
	return (ProjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPublicValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPublic"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sumEstimatedHoursValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sumEstimatedHours"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sumTimeEntriesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sumTimeEntries"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdOn;






@dynamic easyDueDate;






@dynamic homepage;






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





@dynamic partialName;






@dynamic projectDescription;






@dynamic projectIdentifier;






@dynamic status;



- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
}





@dynamic sumEstimatedHours;



- (double)sumEstimatedHoursValue {
	NSNumber *result = [self sumEstimatedHours];
	return [result doubleValue];
}

- (void)setSumEstimatedHoursValue:(double)value_ {
	[self setSumEstimatedHours:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveSumEstimatedHoursValue {
	NSNumber *result = [self primitiveSumEstimatedHours];
	return [result doubleValue];
}

- (void)setPrimitiveSumEstimatedHoursValue:(double)value_ {
	[self setPrimitiveSumEstimatedHours:[NSNumber numberWithDouble:value_]];
}





@dynamic sumTimeEntries;



- (double)sumTimeEntriesValue {
	NSNumber *result = [self sumTimeEntries];
	return [result doubleValue];
}

- (void)setSumTimeEntriesValue:(double)value_ {
	[self setSumTimeEntries:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveSumTimeEntriesValue {
	NSNumber *result = [self primitiveSumTimeEntries];
	return [result doubleValue];
}

- (void)setPrimitiveSumTimeEntriesValue:(double)value_ {
	[self setPrimitiveSumTimeEntries:[NSNumber numberWithDouble:value_]];
}





@dynamic updatedOn;






@dynamic author;

	

@dynamic childProjects;

	
- (NSMutableSet*)childProjectsSet {
	[self willAccessValueForKey:@"childProjects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"childProjects"];
  
	[self didAccessValueForKey:@"childProjects"];
	return result;
}
	

@dynamic issueCategories;

	
- (NSMutableSet*)issueCategoriesSet {
	[self willAccessValueForKey:@"issueCategories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"issueCategories"];
  
	[self didAccessValueForKey:@"issueCategories"];
	return result;
}
	

@dynamic issueDrafts;

	
- (NSMutableSet*)issueDraftsSet {
	[self willAccessValueForKey:@"issueDrafts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"issueDrafts"];
  
	[self didAccessValueForKey:@"issueDrafts"];
	return result;
}
	

@dynamic issues;

	
- (NSMutableSet*)issuesSet {
	[self willAccessValueForKey:@"issues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"issues"];
  
	[self didAccessValueForKey:@"issues"];
	return result;
}
	

@dynamic parentProject;

	

@dynamic trackers;

	
- (NSMutableSet*)trackersSet {
	[self willAccessValueForKey:@"trackers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"trackers"];
  
	[self didAccessValueForKey:@"trackers"];
	return result;
}
	






@end
