//
// NSManagedObjectContext+KFData.h
// KFData
//
// Created by Kyle Fuller on 26/11/2012
// Copyright (c) 2012 Kyle Fuller. All rights reserved
//

#import <CoreData/CoreData.h>

/**
 KFData extensions for NSManagedObjectContext, providing helpers to save and execute blocks.
 */

@interface NSManagedObjectContext (KFData)

// Save (returns if we saved or not)
- (BOOL)save;

/** Save, and propergate changes up parent managed object contexts
 @param error A pointer to an NSError object. You do not need to create an NSError object.
 */
- (BOOL)nestedSave:(NSError **)error;

// Asyncronously save
- (void)performSave;

// Asyncronous nested save
- (void)performNestedSave;

/** Asyncronous perform a block then perform a nested save
 @param writeBlock The block to run on the managed object context.
 @see performWriteBlock:success:failure:
 */
- (void)performWriteBlock:(void(^)(void))writeBlock;

/** Asyncronously perform a block on the managed object context, then run a nested save.

 Once the block has been executed, it will run either the success or the failure block.

 @param writeBlock The block to run on the managed object context.
 @param success A block to run when the write block has been executed, and the managed object context has saved up to it's parent.
 @param failure A block to run when there was a failure to save in the current block, or it's parents.
 @see performWriteBlock:
 */
- (void)performWriteBlock:(void(^)(void))writeBlock
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure;

- (void)obtainPermanentIDsBeforeSaving;

- (void)contextWillSave:(NSNotification*)notification;

@end

