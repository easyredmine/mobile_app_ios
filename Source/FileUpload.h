#import <Mantle.h>

@interface FileUpload : MTLModel <MTLJSONSerializing> {}
// Custom logic goes here.
@property (nonatomic, readonly) NSString *localPath;
@property (nonatomic, readonly) NSURL *localUrl;

@property (nonatomic, strong) NSString* contentType;

@property (nonatomic, strong) NSString* filename;

@property (nonatomic, strong) NSNumber* localIdentifier;

@property (nonatomic, strong) NSString* pathExtension;

@property (nonatomic, strong) NSString* token;

@property (nonatomic, strong) NSNumber* uploadTaskIdentifier;

@end
