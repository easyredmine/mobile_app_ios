#import "GRTValueTransformer.h"

#pragma mark - GRTReversibleValueTransformer

@interface GRTReversibleValueTransformer : GRTValueTransformer
@end

#pragma mark - GRTValueTransformer

@interface GRTValueTransformer ()

@property (copy, nonatomic, readonly) GRTValueTransformerBlock forwardBlock;
@property (copy, nonatomic, readonly) GRTValueTransformerBlock reverseBlock;

- (id)initWithForwardBlock:(GRTValueTransformerBlock)forwardBlock reverseBlock:(GRTValueTransformerBlock)reverseBlock;

@end

@implementation GRTValueTransformer

+ (instancetype)transformerWithBlock:(GRTValueTransformerBlock)block {
    return [[self alloc] initWithForwardBlock:block reverseBlock:nil];
}

+ (instancetype)reversibleTransformerWithBlock:(GRTValueTransformerBlock)block {
    return [self reversibleTransformerWithForwardBlock:block reverseBlock:block];
}

+ (instancetype)reversibleTransformerWithForwardBlock:(GRTValueTransformerBlock)forwardBlock reverseBlock:(GRTValueTransformerBlock)reverseBlock {
    return [[GRTReversibleValueTransformer alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)initWithForwardBlock:(GRTValueTransformerBlock)forwardBlock reverseBlock:(GRTValueTransformerBlock)reverseBlock {
    NSParameterAssert(forwardBlock);
    
    self = [super init];
    
    if (self) {
        _forwardBlock = [forwardBlock copy];
        _reverseBlock = [reverseBlock copy];
    }
    
    return self;
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
	return NO;
}

+ (Class)transformedValueClass {
	return NSObject.class;
}

- (id)transformedValue:(id)value {
	return self.forwardBlock(value);
}

@end

#pragma mark - GRTReversibleValueTransformer

@implementation GRTReversibleValueTransformer

- (id)initWithForwardBlock:(GRTValueTransformerBlock)forwardBlock reverseBlock:(GRTValueTransformerBlock)reverseBlock {
    NSParameterAssert(reverseBlock);
    return [super initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)reverseTransformedValue:(id)value {
	return self.reverseBlock(value);
}

@end
