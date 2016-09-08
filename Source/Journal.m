#import "Journal.h"
#import "UILabel+MaxTextLength.h"

@interface Journal ()

// Private interface goes here.

@end

@implementation Journal

// Custom logic goes here.

-(NSString *)truncatedNotes
{
	NSString *res = self.notes;
	NSUInteger maxLength = [UILabel maxTextLength] -3;
	if(res.length > maxLength){
		res = [[res substringToIndex:maxLength] stringByAppendingString:@"..."];
	}
	return res;
}

@end
