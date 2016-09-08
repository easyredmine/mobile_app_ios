//
//  NSManagedObjectContext+MRResetContext.h
//  EasyRedmine
//
//  Created by Petr Šíma on May/10/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <CoreData/CoreData.h>

//!!!This exposes private MR api, might break if we update MR
@interface NSManagedObjectContext (MRResetContext)

+(void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+(void)MR_setDefaultContext:(NSManagedObjectContext *)context;
@end
