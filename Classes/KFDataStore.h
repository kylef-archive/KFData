//
//  KFDataStore.h
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSManagedObjectContext+KFData.h"
#import "NSManagedObject+KFData.h"
#import "NSManagedObject+Requests.h"
#import "NSManagedObject+Finders.h"
#import "NSManagedObject+Aggregation.h"

@interface KFDataStore : NSObject

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark -

/* Creates a standard local data store which persists to the document directory */
+ (id)standardLocalDataStore;

/* Create a local in-memory data store */
+ (id)standardMemoryDataStore;

#pragma mark -

/* After using init, you will need to manually add the persistent stores.
   Additionally you can use the above `standard` helper methods. The only
   reasons where you would need to manually init are if you want to support
   non-standard object models or custom configurations of your model. */
- (id)init;
- (id)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel;

#pragma mark -

// Create a sub-context with concurrency type
- (NSManagedObjectContext*)managedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

#pragma mark -

// Execute a read-only block on a new private context
- (void)performReadBlock:(void(^)(NSManagedObjectContext* managedObjectContext))readBlock;

// Execute a block and then save and merge the context to the main context
- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
		completionHandler:(void(^)(void))completionHandler;

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock;

// Execute a block on the main (root) context and save
- (void)performWriteBlockOnMainManagedObjectContext:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                                  completionHandler:(void(^)(void))completionHandler;

@end
