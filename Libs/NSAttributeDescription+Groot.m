#import "NSAttributeDescription+Groot.h"
#import "GRTConstants.h"

@implementation NSAttributeDescription (Groot)

- (NSValueTransformer *)grt_JSONTransformer {
    NSString *name = self.userInfo[GRTJSONTransformerNameKey];
    return name ? [NSValueTransformer valueTransformerForName:name] : nil;
}

@end
