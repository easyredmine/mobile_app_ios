// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.m instead.

#import "_Issue.h"

const struct IssueAttributes IssueAttributes = {
	.createdOn = @"createdOn",
	.doneRatio = @"doneRatio",
	.dueDate = @"dueDate",
	.estimatedHours = @"estimatedHours",
	.identifier = @"identifier",
	.isFavorited = @"isFavorited",
	.issueDescription = @"issueDescription",
	.spentHours = @"spentHours",
	.startDate = @"startDate",
	.subject = @"subject",
	.updatedOn = @"updatedOn",
};

const struct IssueRelationships IssueRelationships = {
	.assignedTo = @"assignedTo",
	.attachments = @"attachments",
	.author = @"author",
	.category = @"category",
	.children = @"children",
	.customFields = @"customFields",
	.fixedVersion = @"fixedVersion",
	.haveRelations = @"haveRelations",
	.isInRelations = @"isInRelations",
	.journals = @"journals",
	.parent = @"parent",
	.priority = @"priority",
	.project = @"project",
	.status = @"status",
	.tracker = @"tracker",
};

const struct IssueFetchedProperties IssueFetchedProperties = {
};

@implementation IssueID
@end

@implementation _Issue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Issue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:moc_];
}

- (IssueID*)objectID {
	return (IssueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"doneRatioValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"doneRatio"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"estimatedHoursValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"estimatedHours"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFavoritedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFavorited"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"spentHoursValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"spentHours"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdOn;






@dynamic doneRatio;



- (double)doneRatioValue {
	NSNumber *result = [self doneRatio];
	return [result doubleValue];
}

- (void)setDoneRatioValue:(double)value_ {
	[self setDoneRatio:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDoneRatioValue {
	NSNumber *result = [self primitiveDoneRatio];
	return [result doubleValue];
}

- (void)setPrimitiveDoneRatioValue:(double)value_ {
	[self setPrimitiveDoneRatio:[NSNumber numberWithDouble:value_]];
}





@dynamic dueDate;






@dynamic estimatedHours;



- (double)estimatedHoursValue {
	NSNumber *result = [self estimatedHours];
	return [result doubleValue];
}

- (void)setEstimatedHoursValue:(double)value_ {
	[self setEstimatedHours:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveEstimatedHoursValue {
	NSNumber *result = [self primitiveEstimatedHours];
	return [result doubleValue];
}

- (void)setPrimitiveEstimatedHoursValue:(double)value_ {
	[self setPrimitiveEstimatedHours:[NSNumber numberWithDouble:value_]];
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





@dynamic isFavorited;



- (BOOL)isFavoritedValue {
	NSNumber *result = [self isFavorited];
	return [result boolValue];
}

- (void)setIsFavoritedValue:(BOOL)value_ {
	[self setIsFavorited:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFavoritedValue {
	NSNumber *result = [self primitiveIsFavorited];
	return [result boolValue];
}

- (void)setPrimitiveIsFavoritedValue:(BOOL)value_ {
	[self setPrimitiveIsFavorited:[NSNumber numberWithBool:value_]];
}





@dynamic issueDescription;






@dynamic spentHours;



- (double)spentHoursValue {
	NSNumber *result = [self spentHours];
	return [result doubleValue];
}

- (void)setSpentHoursValue:(double)value_ {
	[self setSpentHours:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveSpentHoursValue {
	NSNumber *result = [self primitiveSpentHours];
	return [result doubleValue];
}

- (void)setPrimitiveSpentHoursValue:(double)value_ {
	[self setPrimitiveSpentHours:[NSNumber numberWithDouble:value_]];
}





@dynamic startDate;






@dynamic subject;






@dynamic updatedOn;






@dynamic assignedTo;

	

@dynamic attachments;

	
- (NSMutableSet*)attachmentsSet {
	[self willAccessValueForKey:@"attachments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attachments"];
  
	[self didAccessValueForKey:@"attachments"];
	return result;
}
	

@dynamic author;

	

@dynamic category;

	

@dynamic children;

	
- (NSMutableSet*)childrenSet {
	[self willAccessValueForKey:@"children"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"children"];
  
	[self didAccessValueForKey:@"children"];
	return result;
}
	

@dynamic customFields;

	
- (NSMutableSet*)customFieldsSet {
	[self willAccessValueForKey:@"customFields"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"customFields"];
  
	[self didAccessValueForKey:@"customFields"];
	return result;
}
	

@dynamic fixedVersion;

	

@dynamic haveRelations;

	
- (NSMutableSet*)haveRelationsSet {
	[self willAccessValueForKey:@"haveRelations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"haveRelations"];
  
	[self didAccessValueForKey:@"haveRelations"];
	return result;
}
	

@dynamic isInRelations;

	
- (NSMutableSet*)isInRelationsSet {
	[self willAccessValueForKey:@"isInRelations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"isInRelations"];
  
	[self didAccessValueForKey:@"isInRelations"];
	return result;
}
	

@dynamic journals;

	
- (NSMutableSet*)journalsSet {
	[self willAccessValueForKey:@"journals"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"journals"];
  
	[self didAccessValueForKey:@"journals"];
	return result;
}
	

@dynamic parent;

	

@dynamic priority;

	

@dynamic project;

	

@dynamic status;

	

@dynamic tracker;

	






@end
