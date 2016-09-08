#import "FileUpload.h"
#import <StandardPaths.h>

@interface FileUpload ()

// Private interface goes here.

@end


@implementation FileUpload

// Custom logic goes here.

-(NSString *)localPath
{
	return [[NSFileManager defaultManager] pathForPublicFile:[NSString stringWithFormat:@"/%@.%@",self.localIdentifier, self.pathExtension]];
}

-(NSURL *)localUrl
{
	return [NSURL fileURLWithPath:self.localPath];
}

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
	return @{
				@"token" : @"token"
				,@"filename" : @"filename"
				,@"contentType" : @"content_type"
				};
}

@end
