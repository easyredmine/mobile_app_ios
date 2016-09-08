// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.h instead.

#import <CoreData/CoreData.h>


extern const struct FileAttributes {
	__unsafe_unretained NSString *contentUrl;
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *descriptionFile;
	__unsafe_unretained NSString *fileName;
	__unsafe_unretained NSString *fileSize;
	__unsafe_unretained NSString *identifier;
} FileAttributes;

extern const struct FileRelationships {
	__unsafe_unretained NSString *issue;
} FileRelationships;

extern const struct FileFetchedProperties {
} FileFetchedProperties;

@class Issue;








@interface FileID : NSManagedObjectID {}
@end

@interface _File : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FileID*)objectID;





@property (nonatomic, strong) NSString* contentUrl;



//- (BOOL)validateContentUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdOn;



//- (BOOL)validateCreatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* descriptionFile;



//- (BOOL)validateDescriptionFile:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fileName;



//- (BOOL)validateFileName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fileSize;



@property int32_t fileSizeValue;
- (int32_t)fileSizeValue;
- (void)setFileSizeValue:(int32_t)value_;

//- (BOOL)validateFileSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Issue *issue;

//- (BOOL)validateIssue:(id*)value_ error:(NSError**)error_;





@end

@interface _File (CoreDataGeneratedAccessors)

@end

@interface _File (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContentUrl;
- (void)setPrimitiveContentUrl:(NSString*)value;




- (NSDate*)primitiveCreatedOn;
- (void)setPrimitiveCreatedOn:(NSDate*)value;




- (NSString*)primitiveDescriptionFile;
- (void)setPrimitiveDescriptionFile:(NSString*)value;




- (NSString*)primitiveFileName;
- (void)setPrimitiveFileName:(NSString*)value;




- (NSNumber*)primitiveFileSize;
- (void)setPrimitiveFileSize:(NSNumber*)value;

- (int32_t)primitiveFileSizeValue;
- (void)setPrimitiveFileSizeValue:(int32_t)value_;




- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;





- (Issue*)primitiveIssue;
- (void)setPrimitiveIssue:(Issue*)value;


@end
