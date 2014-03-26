//
//  KFDataDualStackStore.m
//  KFData
//
//  Created by Kyle Fuller on 11/08/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
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

        /* Not availible on until iOS 7 or OS X 10.9 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreCoordinatorStoresWillChange:) name:@"NSPersistentStoreCoordinatorStoresWillChangeNotification" object:_persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreCoordinatorStoresDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:_persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreCoordinatorDidImportChanges:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:_persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_backgroundManagedObjectContext];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSPersistentStoreCoordinatorStoresWillChangeNotification" object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_backgroundManagedObjectContext];
}

- (void)persistentStoreCoordinatorStoresWillChange:(NSNotification *)notification {
    [_managedObjectContext performBlockAndWait:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextWillReset object:_managedObjectContext userInfo:[notification userInfo]];
        [_managedObjectContext save:nil];
        [_managedObjectContext reset];
    }];

    [_backgroundManagedObjectContext performBlockAndWait:^{
        [_backgroundManagedObjectContext save:nil];
        [_backgroundManagedObjectContext reset];
    }];
}

- (void)persistentStoreCoordinatorStoresDidChange:(NSNotification *)notification {
    [_managedObjectContext performBlock:^{
        [_managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextDidReset object:_managedObjectContext userInfo:[notification userInfo]];
    }];

    [_backgroundManagedObjectContext performBlock:^{
        [_backgroundManagedObjectContext save:nil];
    }];
}

- (void)persistentStoreCoordinatorDidImportChanges:(NSNotification *)notification { }

- (void)managedObjectContextDidSave:(NSNotification *)notification { }

- (NSPersistentStore *)addPersistentStoreWithType:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options error:(NSError **)error {
    NSParameterAssert(storeType != nil);
    return [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:configuration URL:storeURL options:options error:error];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock completion:(void(^)(NSError *error))completion {
    NSParameterAssert(writeBlock != nil);

    [_backgroundManagedObjectContext performBlock:^{
        writeBlock(_backgroundManagedObjectContext);

        if ([_backgroundManagedObjectContext hasChanges]) {
            NSError *error;
            if ([_backgroundManagedObjectContext save:&error]) {
                if (completion) {
                    completion(nil);
                }
            } else if (completion) {
                completion(error);
            }
        } else if (completion) {
            completion(nil);
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

- (void)persistentStoreCoordinatorDidImportChanges:(NSNotification *)notification {
    NSManagedObjectContext *mainManagedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *backgroundManagedObjectContext = self.backgroundManagedObjectContext;

    [mainManagedObjectContext performBlock:^{
        [mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }];

    [backgroundManagedObjectContext performBlock:^{
        NSError *error;
        [backgroundManagedObjectContext save:&error];
        [backgroundManagedObjectContext reset];
    }];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];

    NSManagedObjectContext *mainManagedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *backgroundManagedObjectContext = self.backgroundManagedObjectContext;

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

- (void)persistentStoreCoordinatorDidImportChanges:(NSNotification *)notification {
    NSManagedObjectContext *mainManagedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *backgroundManagedObjectContext = self.backgroundManagedObjectContext;

    [mainManagedObjectContext performBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextWillReset object:mainManagedObjectContext userInfo:[notification userInfo]];
        NSError *error;
        [mainManagedObjectContext save:&error];
        [mainManagedObjectContext reset];
        [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextDidReset object:mainManagedObjectContext userInfo:[notification userInfo]];
    }];

    [backgroundManagedObjectContext performBlock:^{
        NSError *error;
        [backgroundManagedObjectContext save:&error];
        [backgroundManagedObjectContext reset];
    }];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];

    NSManagedObjectContext *mainManagedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *backgroundManagedObjectContext = self.backgroundManagedObjectContext;

    if ([managedObjectContext isEqual:backgroundManagedObjectContext]) {
        [mainManagedObjectContext performBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextWillReset object:mainManagedObjectContext userInfo:[notification userInfo]];
            NSError *error;
            [mainManagedObjectContext save:&error];
            [mainManagedObjectContext reset];
            [[NSNotificationCenter defaultCenter] postNotificationName:KFDataManagedObjectContextDidReset object:mainManagedObjectContext userInfo:[notification userInfo]];
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
