// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CFList.h instead.

#import <CoreData/CoreData.h>
#import "CustomField.h"

extern const struct CFListAttributes {
	__unsafe_unretained NSString *multiple;
	__unsafe_unretained NSString *value;
} CFListAttributes;

extern const struct CFListRelationships {
} CFListRelationships;

extern const struct CFListFetchedProperties {
} CFListFetchedProperties;



@class NSObject;

@interface CFListID : NSManagedObjectID {}
@end

@interface _CFList : CustomField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CFListID*)objectID;





@property (nonatomic, strong) NSNumber* multiple;



@property BOOL multipleValue;
- (BOOL)multipleValue;
- (void)setMultipleValue:(BOOL)value_;

//- (BOOL)validateMultiple:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _CFList (CoreDataGeneratedAccessors)

@end

@interface _CFList (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveMultiple;
- (void)setPrimitiveMultiple:(NSNumber*)value;

- (BOOL)primitiveMultipleValue;
- (void)setPrimitiveMultipleValue:(BOOL)value_;




- (id)primitiveValue;
- (void)setPrimitiveValue:(id)value;




@end
