#import "UserCredentials.h"


@interface UserCredentials ()

// Private interface goes here.

@end


@implementation UserCredentials

// Custom logic goes here.

-(NSURL *)baseUrl
{
	return [NSURL URLWithString:self.baseUrlString];
}

@end
