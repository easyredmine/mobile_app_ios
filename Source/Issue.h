#import "_Issue.h"
#import "SelectionItem.h"

@interface Issue : _Issue {}

@property (nonatomic, readonly) NSString *name;
// Custom logic goes here.
@property(nonatomic, readonly) NSArray *sortedJournals;
@property(nonatomic, readonly) NSArray *sortedJournalsWithNotes;
@property(nonatomic, readonly) NSArray *allRelatives;
@property (nonatomic, readonly) NSArray *sortedAttachments;
@property (nonatomic, strong) NSArray *availableProjects;
@property (nonatomic, strong) NSArray *availableAssignees;
@property (nonatomic, readonly) NSArray *sortedCustomFields;

-(NSAttributedString *)getAttributedDescriptionWithError:(NSError **)error;


@property (nonatomic, readonly) NSString *truncatedDescription;
@end
