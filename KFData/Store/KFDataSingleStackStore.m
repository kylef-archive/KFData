//
//  KFDataDualStackStore.m
//  KFData
//
//  Created by Kyle Fuller on 11/08/2013.
//  Copyright (c) 2013 Kyle Fuller. All rights reserved.
//

#import "KFDataStoreInternal.h"


@implementation KFDataSingleStackStoreBase

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel {
    NSParameterAssert(managedObjectModel != nil);

    if (self = [super init]) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];

        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_backgroundManagedObjectContext];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_backgroundManagedObjectContext];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification { }

- (NSPersistentStore *)addPersistentStoreWithType:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options error:(NSError **)error {
    NSParameterAssert(storeType != nil);
    return [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:configuration URL:storeURL options:options error:error];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    NSParameterAssert(writeBlock != nil);

    [_backgroundManagedObjectContext performBlock:^{
        writeBlock(_backgroundManagedObjectContext);

        if ([_backgroundManagedObjectContext hasChanges]) {
            NSError *error;
            if ([_backgroundManagedObjectContext save:&error]) {
                if (success) {
                    success();
                }
            } else if (failure) {
                failure(error);
            }
        }
    }];
}

- (void)performReadBlock:(void (^)(NSManagedObjectContext *))readBlock {
    NSParameterAssert(readBlock != nil);

    // We create a new context so the read block cannot tamper with any objects
    // in the background context (although, they could call save).
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [managedObjectContext setParentContext:_backgroundManagedObjectContext];

    [managedObjectContext performBlock:^{
        readBlock(managedObjectContext);
    }];
}

@end

@implementation KFDataSingleStackStore

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];

    NSManagedObjectContext *mainManagedObjectContext = [self managedObjectContext];
    NSManagedObjectContext *backgroundManagedObjectContext = [self backgroundManagedObjectContext];

    if ([managedObjectContext isEqual:backgroundManagedObjectContext]) {
        [mainManagedObjectContext performBlock:^{
            [mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    } else if ([managedObjectContext isEqual:mainManagedObjectContext]) {
        [backgroundManagedObjectContext performBlock:^{
            NSError *error;
            [backgroundManagedObjectContext save:&error];
            [backgroundManagedObjectContext reset];
        }];
    }
}

@end

@implementation KFDataSingleResetStackStore

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];

    NSManagedObjectContext *mainManagedObjectContext = [self managedObjectContext];
    NSManagedObjectContext *backgroundManagedObjectContext = [self backgroundManagedObjectContext];

    if ([managedObjectContext isEqual:backgroundManagedObjectContext]) {
        [mainManagedObjectContext performBlock:^{
            NSError *error;
            [mainManagedObjectContext save:&error];
            [mainManagedObjectContext reset];
            [[NSNotificationCenter defaultCenter] postNotificationName:KFDataStoreManagedObjectContextWasReset object:mainManagedObjectContext userInfo:[notification userInfo]];
        }];
    } else if ([managedObjectContext isEqual:mainManagedObjectContext]) {
        [backgroundManagedObjectContext performBlock:^{
            NSError *error;
            [backgroundManagedObjectContext save:&error];
            [backgroundManagedObjectContext reset];
        }];
    }
}

@end
