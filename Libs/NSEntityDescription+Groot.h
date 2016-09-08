#import <CoreData/CoreData.h>

@interface NSEntityDescription (Groot)

- (NSAttributeDescription *)grt_identityAttribute;
- (NSString *)grt_typeKeyPath;
- (id)grt_typeValue;
- (BOOL)grt_shouldEvaluateSubentities;
@end
