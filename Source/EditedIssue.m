//
//  EditedIssue.m
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/28/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "EditedIssue.h"
#import <TransformerKit/NSValueTransformer+TransformerKit.h>

@implementation EditedIssue

static NSString *const ValueTransformerName = @"EditedIssueValueTransformerName";
static NSString *const FileUploadTransformerName = @"FileUploadTransformerName";
static NSString *const StringValueTransformerName = @"StringValueTrasnformerName";

+(void)load
{
	[super load];
	[NSValueTransformer registerValueTransformerWithName:ValueTransformerName transformedValueClass:[NSDictionary class] returningTransformedValueWithBlock:^id(id value) {
		return value ? @{@"value" : value} : @{@"value" : NSNull.null};
	} allowingReverseTransformationWithBlock:^id(id value) {
        id newValue = value[@"value"];
        if (!newValue) {
            newValue = value[@"id"];
        }
		return newValue;
	}];

}

-(instancetype)init
{
	if(self = [super init]){
		[self commonInit];
	}
	return self;
}

-(instancetype)initWithIssue:(Issue *)issue
{
	if(self = [super init]){
		[self commonInit];
		
		self.subject = issue.subject;
		self.issueDescription = issue.issueDescription;
		self.identifier = issue.identifier;
		self.estimatedHours = issue.estimatedHours;
		if(issue.assignedTo.identifier){ //check against identifier, api sends object with <null> id, so groot creates an empty MembeshipItem object
			self.assignedTo = @{@"value" : issue.assignedTo.identifier, @"name" : issue.assignedTo.name};
		}
		if(issue.parent.identifier) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:issue.parent.identifier forKey:@"value"];
            
            if (issue.parent.name) {
                [dict setObject:issue.parent.name forKey:@"name"];
            }
            
            self.parent = dict;
		}
		if(issue.project.identifier){
			self.project = @{@"value" : issue.project.identifier, @"name" : issue.project.name};
		}
		if(issue.tracker.identifier){
			self.tracker = @{@"value" : issue.tracker.identifier, @"name" : issue.tracker.name};
		}
		if(issue.status.identifier){
			self.status = @{@"value" : issue.status.identifier, @"name" : issue.status.name};
		}
		if(issue.priority.identifier){
			self.priority = @{@"value" : issue.priority.identifier, @"name" : issue.priority.name};
		}
		if(issue.category.identifier){
			self.category = @{@"value" : issue.category.identifier, @"name" : issue.category.name};
		}
		if(issue.fixedVersion.identifier){
			self.fixedVersion = @{@"value" : issue.fixedVersion.identifier, @"name" : issue.fixedVersion.name};
		}
		
		self.dueDate = issue.dueDate;
		self.startDate = issue.startDate;
		self.doneRatio = issue.doneRatio;
		
		self.customFields = [[issue.sortedCustomFields.rac_sequence filter:^BOOL(CustomField *cf) {
			return [[cf class] isEditable];
		}] map:^id(CustomField *cf) {
			id value = [cf value];
			if([cf isKindOfClass:[CFBool class]]){
				value = @([value boolValue]); //nil -> NO
			}
			if([cf isKindOfClass:[CFDate class]]){
				;
			}
			if([cf isKindOfClass:[CFList class]]){ //core data array transformer only fires when moc is saved. so [cf value] can still be string, convert it to array here
				if(value && ![value isKindOfClass:[NSArray class]]){
					value = @[value];
				}
			}
			NSMutableDictionary *res = [@{@"value" : value?:[NSNull null],
													@"field_format" : cf.fieldFormat,
													@"name" : cf.name,
													@"id" : cf.identifier
													} mutableCopy];
			if([cf respondsToSelector:@selector(multiple)]){
				res[@"multiple"] = @([[(id)cf multiple] boolValue]);
			}
			return res;
		}].array;
		
	}
	return self;
}

-(void)commonInit
{
	self.doneRatio = @(0);
	self.fileUploads = [NSMutableArray array];
}

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
	return @{
				@"subject" : @"subject"
				,@"issueDescription" : @"description"
				,@"identifier" : @"id"
				,@"estimatedHours" : @"estimated_hours"
				,@"assignedTo" : @"assigned_to_id"
				,@"parent" : @"parent_issue_id"
				,@"project" : @"project_id"
				,@"tracker" : @"tracker_id"
				,@"status" : @"status_id"
				,@"priority" : @"priority_id"
				,@"category" : @"category_id"
				,@"fixedVersion" : @"fixed_version_id"
				,@"dueDate" : @"due_date"
				,@"startDate" : @"start_date"
				,@"doneRatio" : @"done_ratio"
                ,@"notes" : @"notes"
//				,@"customFields" : @"custom_fields"
				//TODO: watchers
				//TODO: is_private
				//TODO: notes
				//TODO: private_notes
				
				,@"fileUploads" : @"uploads"
				};
	

}

+(NSValueTransformer *)assignedToJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)parentJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)projectJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)trackerJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)statusJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)priorityJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)categoryJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)fixedVersionJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:ValueTransformerName];
}

+(NSValueTransformer *)dueDateJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:RMDateTransformerName];
}

+(NSValueTransformer *)startDateJSONTransformer
{
	return [NSValueTransformer valueTransformerForName:RMDateTransformerName];
}


+(NSValueTransformer *)fileUploadsJSONTransformer
{
	return [MTLJSONAdapter arrayTransformerWithModelClass:FileUpload.class];
}



@end
