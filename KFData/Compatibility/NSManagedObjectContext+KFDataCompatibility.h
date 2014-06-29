//
//  NNSManagedObjectContext+KFDataCompatibility.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>

/// This extension provides compatibility with KFData pre 1.0
@interface NSManagedObjectContext (KFDataCompatibility)

/// Replaced by performWriteBlock:completion:
- (void)performWriteBlock:(void (^)(NSManagedObjectContext* managedObjectContext))writeBlock __deprecated;

/// Replaced by performWriteBlock:completion:
- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock success:(void(^)(void))success failure:(void(^)(NSError *error))failure __deprecated;

@end

