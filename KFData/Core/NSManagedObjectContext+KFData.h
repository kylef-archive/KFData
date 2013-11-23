//
//  NSManagedObjectContext+KFData.h
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (KFData)

/**
 Asyncronously execute a block and then save changes to the context.
 Executing a completion block when complete.

 @param writeBlock The block to run on the managed object context.
 @param completion A block to run once the write block has completed, the error will be nil if it the save was successful.
 */

- (void)performWriteBlock:(void(^)(void))writeBlock completion:(void(^)(NSError *error))completion __attribute((nonnull(1)));

@end
