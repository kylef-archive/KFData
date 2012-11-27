//
//  KFDataStore.h
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSManagedObject+KFData.h"
#import "NSManagedObjectContext+KFData.h"

@interface KFDataStore : NSObject

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;


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

@end
