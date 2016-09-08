#import "Issue.h"
#import "UILabel+MaxTextLength.h"

@interface Issue ()

// Private interface goes here.

@end

@implementation Issue

@synthesize availableProjects = _availableProjects;
@synthesize availableAssignees = _availableAssignees;

// Custom logic goes here.
-(NSArray*) sortedJournals
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                                 ascending:[UserDefaults boolForKey:kJournalOrderAsc]];
   
      return  [[self.journals allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}
-(NSArray*) sortedJournalsWithNotes
{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                                 ascending:[UserDefaults boolForKey:kJournalOrderAsc]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notes!=nil AND notes!=''"];
    
     return  [[[self.journals allObjects] filteredArrayUsingPredicate:predicate]
                sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}


-(NSString *)name
{
	return self.subject;
}


-(NSArray*) allRelatives
{
    return [[self.haveRelations allObjects] arrayByAddingObjectsFromArray:[self.isInRelations allObjects]];
}


-(NSArray *)sortedAttachments
{
	return [self.attachments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]]];
}


-(NSAttributedString *)getAttributedDescriptionWithError:(NSError **)error
{
	return  [[NSAttributedString alloc] initWithData:[self.issueDescription dataUsingEncoding:NSUTF8StringEncoding]
																									  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
																													NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
											documentAttributes:nil error:error];
}


-(NSArray *)sortedCustomFields
{
	return [self.customFields sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]]];
}


-(NSString *)truncatedDescription
{
	NSString *res = self.issueDescription;
	NSUInteger maxLength = [UILabel maxTextLength] -3;
	if(res.length > maxLength){
		res = [[res substringToIndex:maxLength] stringByAppendingString:@"..."];
	}
	return res;
}
@end
