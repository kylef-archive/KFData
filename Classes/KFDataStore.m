//
//  KFDataStore.m
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataStore.h"

#define kKFDataStoreLocalFilename @"localStore.sqlite"

@interface KFDataStore ()

@end

@implementation KFDataStore

+ (NSURL*)storesDirectoryURL {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storesDirectoryURL = [NSURL fileURLWithPath:documentsDirectory];
    storesDirectoryURL = [storesDirectoryURL URLByAppendingPathComponent:@"DataStores"];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[storesDirectoryURL path]] == NO) {
        NSError *error;

        BOOL createSuccess = [fileManager createDirectoryAtURL:storesDirectoryURL
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error];

        if (createSuccess == NO) {
            NSLog(@"KFData: Unable to create application sandbox stores directory: %@\n\tError: %@", storesDirectoryURL, error);
        }
    }

    return storesDirectoryURL;
}

+ (id)standardLocalDataStore {
    return [self standardLocalDataStoreForce:NO];
}

+ (id)standardLocalDataStoreForce:(BOOL)forced {
    KFDataStore *dataStore = [[KFDataStore alloc] init];

    [[dataStore managedObjectContext] performBlock:^{
        NSURL *storesDirectoryURL = [self storesDirectoryURL];
        NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:kKFDataStoreLocalFilename];

        @try {
            [dataStore addLocalStore:nil URL:storeURL];
        } @catch (NSException *exception) {
            NSLog(@"%@", [exception name]);

            if (forced && [[NSFileManager defaultManager] isDeletableFileAtPath:[storeURL path]]) {
                NSError *error;

                if ([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
                    NSLog(@"KFData: Forced local data store");
                    [dataStore addLocalStore:nil URL:storeURL];
                } else {
                    NSLog(@"KFData: Failed to force remove store: %@", error);
                }
            }
        }
    }];
    
    return dataStore;
}

+ (id)standardMemoryDataStore {
    KFDataStore *dataStore = [[KFDataStore alloc] init];
    [[dataStore managedObjectContext] performBlock:^{
        [dataStore addMemoryStore:nil];
    }];

    return dataStore;
}

#pragma mark -

- (id)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel {
    if (self = [super init]) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }

    return self;
}

- (id)init {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    if (self = [self initWithManagedObjectModel:managedObjectModel]) {
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Stores

- (NSPersistentStore*)addMemoryStore:(NSString*)configuration {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    NSError *error;

    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                        configuration:configuration
                                                                                  URL:nil
                                                                              options:nil
                                                                                error:&error];
    if (store == nil) {
        NSLog(@"KFData: Unable to add memory store: %@", error);
    }

    return store;
}

- (NSPersistentStore*)addLocalStore:(NSString*)configuration URL:(NSURL*)storeURL {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    NSError *error;

    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                        configuration:configuration
                                                                                  URL:storeURL
                                                                              options:nil
                                                                                error:&error];

    if (store == nil) {
        NSLog(@"KFData: Unable to add local store: %@", error);
    }

    return store;
}

#pragma mark -

- (NSManagedObjectContext*)managedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [context setParentContext:[self managedObjectContext]];
    return context;
}

- (void)performReadBlock:(void(^)(NSManagedObjectContext* managedObjectContext))readBlock {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

    [managedObjectContext performBlock:^{
        readBlock(managedObjectContext);
    }];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

    [managedObjectContext performWriteBlock:^{
        writeBlock(managedObjectContext);
    } success:success failure:failure];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock {
    [self performWriteBlock:writeBlock success:nil failure:nil];
}

- (void)performWriteBlockOnMainManagedObjectContext:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                                  completionHandler:(void(^)(void))completionHandler
{
    [[self managedObjectContext] performBlock:^{
        writeBlock([self managedObjectContext]);

        [[self managedObjectContext] save];

        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)performWriteBlockOnMainManagedObjectContext:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
{
    [self performWriteBlockOnMainManagedObjectContext:writeBlock completionHandler:nil];
}

@end
