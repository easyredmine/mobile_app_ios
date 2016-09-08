#import "_CustomField.h"

@interface CustomField : _CustomField {}
// Custom logic goes here.
@property (nonatomic, strong) id value;

+(BOOL)isEditable; //defaults to YES, subclasses can disable editation

@end
