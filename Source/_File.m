// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.m instead.

#import "_File.h"

const struct FileAttributes FileAttributes = {
	.contentUrl = @"contentUrl",
	.createdOn = @"createdOn",
	.descriptionFile = @"descriptionFile",
	.fileName = @"fileName",
	.fileSize = @"fileSize",
	.identifier = @"identifier",
};

const struct FileRelationships FileRelationships = {
	.issue = @"issue",
};

const struct FileFetchedProperties FileFetchedProperties = {
};

@implementation FileID
@end

@implementation _File

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"File";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"File" inManagedObjectContext:moc_];
}

- (FileID*)objectID {
	return (FileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"fileSizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fileSize"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic contentUrl;






@dynamic createdOn;






@dynamic descriptionFile;






@dynamic fileName;






@dynamic fileSize;



- (int32_t)fileSizeValue {
	NSNumber *result = [self fileSize];
	return [result intValue];
}

- (void)setFileSizeValue:(int32_t)value_ {
	[self setFileSize:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFileSizeValue {
	NSNumber *result = [self primitiveFileSize];
	return [result intValue];
}

- (void)setPrimitiveFileSizeValue:(int32_t)value_ {
	[self setPrimitiveFileSize:[NSNumber numberWithInt:value_]];
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





@dynamic issue;

	






@end
