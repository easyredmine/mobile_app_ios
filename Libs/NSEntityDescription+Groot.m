#import "NSEntityDescription+Groot.h"
#import "GRTConstants.h"

@implementation NSEntityDescription (Groot)

- (NSAttributeDescription *)grt_identityAttribute {
	
	NSString *identityAttribute = nil;
	NSEntityDescription *entityDescription = self;
	
	while (entityDescription && !identityAttribute) {
		identityAttribute = entityDescription.userInfo[GRTIdentityAttributeKey];
		entityDescription = entityDescription.superentity;
	}

    if(!identityAttribute) {
        identityAttribute = @"identifier";
    }

	if (identityAttribute) {
		return self.attributesByName[identityAttribute];
	}
	
    
	return nil;
}

-(NSString *)grt_typeKeyPath
{
	NSString *typeKeyPath = nil;
	NSEntityDescription *entityDescription = self;
	
	while (entityDescription && !typeKeyPath) {
		typeKeyPath = entityDescription.userInfo[GRTTypeKeyPathKey];
		entityDescription = entityDescription.superentity;
	}
	
	return typeKeyPath;
}

-(id)grt_typeValue
{
	NSString *typeValue = self.userInfo[GRTTypeValueKey];
	
	if(!typeValue){
		return self.name;
	}
	
	typeValue = [typeValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
	NSArray *tokens = [typeValue componentsSeparatedByString:@"\",\""];
	if(tokens.count == 1) return tokens.firstObject;
	
	return tokens;
}

-(BOOL)grt_shouldEvaluateSubentities
{
	BOOL result = YES;
	NSString *noOrFalseOr1 = self.userInfo[GRTEvaluateSubentitiesKey];
		if ([[noOrFalseOr1 lowercaseString] isEqualToString:@"no"]
			 || [[noOrFalseOr1 lowercaseString] isEqualToString:@"false"]
			 || [noOrFalseOr1 isEqualToString:@"0"]) {
			result = NO;
	}
	if(self.subentities.count == 0){
		result = NO;
	}
	
	//changed to default to YES
//		BOOL result = NO;
//	NSString *yesOrTrueOr1 = self.userInfo[GRTEvaluateSubentitiesKey];
//	if ([[yesOrTrueOr1 lowercaseString] isEqualToString:@"yes"]
//		 || [[yesOrTrueOr1 lowercaseString] isEqualToString:@"true"]
//		 || [yesOrTrueOr1 isEqualToString:@"1"]) {
//		result = YES;
//	}
//	if(!result){
//		result = self.isAbstract; 
//	}
	
	return result;
}

@end
