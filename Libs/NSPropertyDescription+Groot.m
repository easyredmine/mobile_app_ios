#import "NSPropertyDescription+Groot.h"
#import "GRTConstants.h"
#import "GRTValueTransformer.h"
#import <TTTStringTransformers.h>

static BOOL GRTIsNullKeyPath(NSString *keyPath) {
    return [keyPath isEqual:NSNull.null] || [keyPath isEqualToString:@"null"];
}

@implementation NSPropertyDescription (Groot)


NSString *const GRTKeyPathTransformerName = @"GRTKeyPathTransformer";

__attribute__((constructor)) static void initializeTranformer(void)
{
	// do stuff
	NSValueTransformer *t = [GRTValueTransformer transformerWithBlock:^id(id value) {
		if([value isEqual:@"identifier"]){
			return @"id";
		}else{
			NSString *whitespaced = [[NSValueTransformer valueTransformerForName:TTTLlamaCaseStringTransformerName] reverseTransformedValue:value];
			return [[NSValueTransformer valueTransformerForName:TTTSnakeCaseStringTransformerName] transformedValue:whitespaced];
		}
	}];
	[NSValueTransformer setValueTransformer:t forName:GRTKeyPathTransformerName];

}

- (NSString *)grt_JSONKeyPath {
    NSString *JSONKeyPath = self.userInfo[GRTJSONKeyPathKey];
    
    if (GRTIsNullKeyPath(JSONKeyPath)) {
        return nil;
    }
	
	
    return JSONKeyPath ? : [[NSValueTransformer valueTransformerForName:GRTKeyPathTransformerName] transformedValue:self.name];
}

-(BOOL)grt_resetOnMerge
{
	return [self.userInfo[GRTResetOnMergeKey] isEqual:@"true"];
}

@end
