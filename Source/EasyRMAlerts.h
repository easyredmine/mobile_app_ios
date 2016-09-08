//
//  EasyRMAlerts.h
//  EasyRedmine
//
//  Created by Honza Řečínský on 26/03/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyRMAlerts : NSObject

typedef void (^AlertSuccessBlock) ();

+ (void) showAlertWithTitle:(NSString *) title andDescription:(NSString*)message block:(AlertSuccessBlock) successBlock;

+ (void) showDialogWithTitle:(NSString *) title andDescription:(NSString*)message block:(AlertSuccessBlock) successBlock;

@end
