//
//  KFDataStore.h
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 When using a main managed object context from a KFDataStore, it is important that you listen for this notification.
 When this notification is fired, you should discard any managed object's you received previous because the managed object context was reset.
 
 This notification will be fired on the main thread.
 */
NSString * const KFDataManagedObjectContextWillReset;
NSString * const KFDataManagedObjectContextDidReset;


typedef NS_ENUM(NSUInteger, KFDataStoreConfigurationType) {
    /**
     This is the simplest, we have a single persistent store coordinator with
     two managed object context's, one for the UI and one for any asyncronous
     or background tasks.
     */
    KFDataStoreConfigurationTypeSingleStack,

    /**
     This is similar to the single stack configuration, although instead of
     merging changes from the import managed object context. It will instead
     call save on the main and then reset:. It is important that you listen
     for the KFDataStoreManagedObjectContextWasReset notification and reload
     your userinterface when this happens.

     It is useful to do when your background context is used for importing a
     large amount of data and you do not wish to trigger multiple changes with
     a fetched results controller. Instead you can perform a refetch on the
     notification.
     */
    KFDataStoreConfigurationTypeSingleResetStack,

    /**
     This will create a dual persistent coordinator stack. To make use of write
     ahead lock (WAL). We can write into one stack and read from the other
     without blocking.
     
     It is important that you do not share managed object ID's between
     asyncronous blocks and UI blocks. Instead you should use -URIRepresentation.
     
     You should not keep object's alive outside of the asyncronous blocks. They
     will become invalid after the block is executed.
     */
    KFDataStoreConfigurationTypeDualStack,

    /**
     This is similar to the dual stack configuration, although instead of
     merging changes from the import managed object context. It will instead
     call save on the main and then reset:. It is important that you listen
     for the KFDataStoreManagedObjectContextWasReset notification and reload
     your userinterface when this happens.
     
     It is useful to do when your background context is used for importing a
     large amount of data and you do not wish to trigger multiple changes with
     a fetched results controller. Instead you can perform a refetch on the
     notification.
     */
    KFDataStoreConfigurationTypeDualResetStack,
};

/**
 KFDataStore is a wrapper around a Core Data stack. You would normally create a
 single instance of KFDataStore to use with a single managed object model.
 
 This class is a class cluster and the internal implementation can differ
depending on which KFDataStoreConfigurationType you have chosen.
*/

@interface KFDataStore : NSObject

+ (instancetype)storeWithConfigurationType:(KFDataStoreConfigurationType)configurationType;

+ (instancetype)storeWithConfigurationType:(KFDataStoreConfigurationType)configurationType managedObjectModel:(NSManagedObjectModel*)managedObjectModel;

#pragma mark -

/**
 After creating a store, you will need to manually add the persistent stores.
 Additionally you can use the following helper methods. The only
 reasons where you would need to manually create a store is if you want to
 choose your own configuration type, or you want to use a different managed
 object model other than the default.
 */

/** Creates a standard data store which persists to the document directory.
 This uses the dual stack configuration mode, and it will store data in the
 applications sandbox at `/Documents/DataStores/localStore.sqlite`

 It will use automatically migrate persistent stores and infer the mapping
 model while doing so.

 @param error If there is a problem creating the store, upon return contains an instance of NSError that describes the problem.
 @return The data store configured for local persistence.
*/

+ (instancetype)standardLocalDataStore:(NSError **)error;

/** Create a in-memory data store, it will use the single stack configuration mode
 @param error If there is a problem creating the store, upon return contains an instance of NSError that describes the problem.
 @return The data store configured for memory persistence.
 */

+ (instancetype)standardMemoryDataStore:(NSError **)error;

/** Create a iCloud data store, it will use the single stack configuration mode
 @param error If there is a problem creating the store, upon return contains an instance of NSError that describes the problem.
 @return The data store configured for cloud persistence.
 */

+ (instancetype)standardCloudDataStore:(NSError **)error;

#pragma mark -

/** Although the following methods return a persistent store, it should be
 important to note that this will only be the persistent store associated
 with the main managed object context. In the case of a dual stack, there
 will actually be two persistent stores.
 */

- (NSPersistentStore *)addPersistentStoreWithType:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options error:(NSError **)error;

- (NSPersistentStore *)addMemoryStore:(NSString *)configuration error:(NSError **)error;

- (NSPersistentStore *)addLocalStore:(NSString *)filename configuration:(NSString *)configuration options:(NSDictionary *)options error:(NSError **)error;

- (NSPersistentStore *)addCloudStore:(NSString *)filename configuration:(NSString *)configuration contentNameKey:(NSString *)contentNameKey error:(NSError **)error;

#pragma mark -

/** Although the persistent store coordinator is exposed. It should be noted
 that their may be multiple persistent stores depending on the configuration.

 This will return the persistent store coordinator which is used by the main
 thread managed object context.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

/** This method will always return a managed object context on the main thread.
 This is meant for using with the UI such as with a fetched results controller.

 It will always merge data from any asyncronous write blocks, but in the case of
 the special "reset" configuration type. You will need to refetch and reload
 any data. Existing managed object's will be invalid.
 */
- (NSManagedObjectContext *)managedObjectContext;

/** This method will always return a managed object context which uses a private queue.

 It will always merge data from the main managed object context, however in most
 cases this context will be reset so you shouldn't save any object outside of
 the perform block methods.
 */
- (NSManagedObjectContext *)backgroundManagedObjectContext;

#pragma mark - Performing Block Operations

/** @name Performing Block Operations */

/** Asyncronously execute a read-only block.
 @param readBlock The block to perform
 @see performWriteBlock:
*/
- (void)performReadBlock:(void (^)(NSManagedObjectContext* managedObjectContext))readBlock;

/**
 Asyncronously execute a block and then save changes to the persistent store.
 Executing a completion block when complete.

 @param writeBlock The block to run on the managed object context.
 @param completion A block to run once the write block has completed, the error will be nil if it the save was successful.
*/

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock completion:(void(^)(NSError *error))completion;

@end
