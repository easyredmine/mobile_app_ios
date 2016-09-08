//
//  OpenUrlHelper.m
//  EasyRedmine
//
//  Created by Honza Řečínský on 10/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import "OpenUrlHelper.h"
#import "FilterManager.h"
#import <AFNetworking.h>

@implementation OpenUrlHelper

+(void) openProjectDetail:(Project*)project
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/projects/%@",[UserDefaults stringForKey:kLogedBaseUrl],project.projectIdentifier];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

+(void) openIssueDetail:(Issue*)issue
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/issues/%@",[UserDefaults stringForKey:kLogedBaseUrl],issue.identifier];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

+(void) openIssuesWithFilter
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/issues",[UserDefaults stringForKey:kLogedBaseUrl]];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:stringUrl parameters:[[FilterManager sharedService] getUrlParametersActiveFilter] error:nil];
    [[UIApplication sharedApplication] openURL:request.URL];
}
@end
