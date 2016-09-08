#import "NSDictionary+Groot.h"
#import "NSPropertyDescription+Groot.h"
#import "NSAttributeDescription+Groot.h"

@implementation NSDictionary (Groot)

- (id)grt_valueForAttribute:(NSAttributeDescription *)attribute {
    id value = [self valueForKeyPath:[attribute grt_JSONKeyPath]];
    
    if ([value isEqual:NSNull.null]) {
        value = nil;
    }
    
    if (value != nil) {
        NSValueTransformer *transformer = [attribute grt_JSONTransformer];
        if (transformer) {
            value = [transformer transformedValue:value];
        }
    }
    
    return value;
}

@end
