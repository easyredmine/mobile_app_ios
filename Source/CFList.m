#import "CFList.h"
#import <NSValueTransformer+TransformerKit.h>


@interface CFList ()

// Private interface goes here.

@end


@implementation CFList

// Custom logic goes here.
+(void)load
{
	[super load];
	[NSValueTransformer registerValueTransformerWithName:@"ArrayTransformer" transformedValueClass:[NSArray class] returningTransformedValueWithBlock:^id(id value) {
//		if(![value isKindOfClass:[NSArray class]]){ //moved to groot parsing
//			value = @[value];
//		}
		return [NSKeyedArchiver archivedDataWithRootObject:value];
	} allowingReverseTransformationWithBlock:^id(id value) {
		id res = [NSKeyedUnarchiver unarchiveObjectWithData:value];
		return res;
	}];
}

@end
