//
//  KFDataStore.h
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KFManagedObjectContext;

/**
 KFDataStore is a wrapper around an NSPersistentStoreCoordinator. You would
 normally create a single instance of KFDataStore to use across the whole
 of your application. Then you would run
 managedObjectContextWithConcurrencyType: to get hold of a managed object
 context. Alternatively you can use performWriteBlock: and performReadBlock:
 to run a block.
*/

@interface KFDataStore : NSObject

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/** Creates a standard data store which persists to the document directory.

 This data store will be stored in the applications sandbox at `/Documents/DataStores/localStore.sqlite`
 @see standardLocalDataStoreForce:
*/

+ (instancetype)standardLocalDataStore;

/** Creates a standard data store which persists to the document directory.

 This data store will be stored in the applications sandbox at `/Documents/DataStores/localStore.sqlite`
 @param force Force loading the store, if the existing store is incompatible. Remove it.
 @see standardLocalDataStore
*/

+ (instancetype)standardLocalDataStoreForce:(BOOL)forced;

/** Create a local in-memory data store */

+ (instancetype)standardMemoryDataStore;

/** Create a local store which persists to the document directory but with custom managed object model */

+ (instancetype)localDataStoreWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel;

#pragma mark - Initialization
/** @name Initialization */

/**
 After using init, you will need to manually add the persistent stores.
 Additionally you can use the `standardLocalDataStore` helper method. The only
 reasons where you would need to manually init are if you want to support
 non-standard object models or custom configurations of your model.

 @see standardLocalDataStore
*/
- (instancetype)init;
- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel;

#pragma mark -

/** Create a sub-context with concurrency type.
 @param concurrencyType The concurrency pattern with which context will be used.
 @return A context initialized to use the given concurrency type.
 */
- (KFManagedObjectContext *)managedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

#pragma mark - Performing Block Operations
/** @name Performing Block Operations */

/** Asyncronously execute a read-only block on a new private context
 @param readBlock The block to perform
 @see performWriteBlock:
*/
- (void)performReadBlock:(void (^)(NSManagedObjectContext* managedObjectContext))readBlock;

/**
 Asyncronously execute a block and then save the changes into the main
 context (and persistent store).

 @param writeBlock The block to perform
 @see performWriteBlock:success:failure:
*/
- (void)performWriteBlock:(void (^)(NSManagedObjectContext* managedObjectContext))writeBlock;

/**
 Asyncronously execute a block and then save the changes into the main
 context and persistent store. But execute a completion block when
 this has been saved.

 @param writeBlock The block to run on the managed object context.
 @param success A block to run when the write block has been executed, and the managed object context has saved up to it's parent.
 @param failure A block to run when there was a failure to save in the current block, or it's parents.
 @see performWriteBlock:
*/
- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure;

// Execute a block on the main (root) context and save
- (void)performWriteBlockOnMainManagedObjectContext:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                                  completionHandler:(void(^)(void))completionHandler __deprecated;

@end
