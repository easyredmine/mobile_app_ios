// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Journal.h instead.

#import <CoreData/CoreData.h>


extern const struct JournalAttributes {
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *notes;
} JournalAttributes;

extern const struct JournalRelationships {
	__unsafe_unretained NSString *issue;
	__unsafe_unretained NSString *user;
} JournalRelationships;

extern const struct JournalFetchedProperties {
} JournalFetchedProperties;

@class Issue;
@class MembershipItem;





@interface JournalID : NSManagedObjectID {}
@end

@interface _Journal : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JournalID*)objectID;





@property (nonatomic, strong) NSDate* createdOn;



//- (BOOL)validateCreatedOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identifier;



@property int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Issue *issue;

//- (BOOL)validateIssue:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) MembershipItem *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Journal (CoreDataGeneratedAccessors)

@end

@interface _Journal (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedOn;
- (void)setPrimitiveCreatedOn:(NSDate*)value;




- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;





- (Issue*)primitiveIssue;
- (void)setPrimitiveIssue:(Issue*)value;



- (MembershipItem*)primitiveUser;
- (void)setPrimitiveUser:(MembershipItem*)value;


@end
