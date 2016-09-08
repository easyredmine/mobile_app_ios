#import <Foundation/Foundation.h>

typedef id (^GRTValueTransformerBlock)(id value);

/**
 Generic block-based value transformer.
 */
@interface GRTValueTransformer : NSValueTransformer

/**
 Returns a transformer which transforms values using the given block. Reverse transformations will not be allowed.
 */
+ (instancetype)transformerWithBlock:(GRTValueTransformerBlock)block;

/**
 Returns a transformer which transforms values using the given block, for forward or reverse transformations.
 */
+ (instancetype)reversibleTransformerWithBlock:(GRTValueTransformerBlock)block;

/**
 Returns a transformer which transforms values using the given blocks.
 */
+ (instancetype)reversibleTransformerWithForwardBlock:(GRTValueTransformerBlock)forwardBlock reverseBlock:(GRTValueTransformerBlock)reverseBlock;

@end
