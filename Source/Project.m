#import "Project.h"
#import "UILabel+MaxTextLength.h"


@interface Project ()

// Private interface goes here.

@end
@implementation Project
- (NSString*)name {
    NSString *name = self.partialName;
    Project *project = self.parentProject;
    while (true) {
        if (project) {
            name = [NSString stringWithFormat:@"%@ / %@",project.partialName,name];
            project = project.parentProject;
        }else{
            break;
        }
    }
    return name;
}

-(NSString *)truncatedDescription
{
	NSString *res = self.projectDescription;
	NSUInteger maxLength = [UILabel maxTextLength] -3;
	if(res.length > maxLength){
		res = [[res substringToIndex:maxLength] stringByAppendingString:@"..."];
	}
	return res;
}
@end
