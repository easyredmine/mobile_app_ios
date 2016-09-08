//
//  SelectionItem.h
//  EasyRedmine
//
//  Created by Petr Šíma on Apr/2/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectionItem <NSObject>
@property (nonatomic, readonly) NSString *name;
@end