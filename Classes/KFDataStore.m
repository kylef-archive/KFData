//
//  KFDataStore.m
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataStore.h"
#import "KFManagedObjectContext.h"
#import "NSManagedObjectContext+KFData.h"

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

+ (instancetype)standardLocalDataStore {
    return [self standardLocalDataStoreForce:NO options:nil];
}

+ (instancetype)standardLocalDataStoreWithOptions:(NSDictionary *)options {
    return [self standardLocalDataStoreForce:NO options:options];
}

+ (instancetype)standardLocalDataStoreForce:(BOOL)forced options:(NSDictionary *)options {
    KFDataStore *dataStore = [[KFDataStore alloc] init];

    [dataStore addLocalStoreForced:forced options:options];
    
    return dataStore;
}

+ (instancetype)localDataStoreWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    KFDataStore *dataStore = [[KFDataStore alloc] initWithManagedObjectModel:managedObjectModel];

    [dataStore addLocalStoreForced:NO options:nil];

    return dataStore;
}

+ (instancetype)standardMemoryDataStore {
    KFDataStore *dataStore = [[KFDataStore alloc] init];
    [[dataStore managedObjectContext] performBlock:^{
        [dataStore addMemoryStore:nil];
    }];

    return dataStore;
}

#pragma mark -

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel {
    if (self = [super init]) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }

    return self;
}

- (instancetype)init {
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

- (void)addLocalStoreForced:(BOOL)forced options:(NSDictionary *)options {
    [[self managedObjectContext] performBlock:^{
        NSURL *storesDirectoryURL = [KFDataStore storesDirectoryURL];
        NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:kKFDataStoreLocalFilename];

        @try {
            [self addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options];
        } @catch (NSException *exception) {
            NSLog(@"%@", [exception name]);

            if (forced && [[NSFileManager defaultManager] isDeletableFileAtPath:[storeURL path]]) {
                NSError *error;

                if ([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
                    NSLog(@"KFData: Forced local data store");
                    [self addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil];
                } else {
                    NSLog(@"KFData: Failed to force remove store: %@", error);
                }
            }
        }
    }];
}

- (NSPersistentStore *)addPersistentStoreWithType:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    NSError *error;

    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:storeType
                                                                        configuration:configuration
                                                                                  URL:storeURL
                                                                              options:options
                                                                                error:&error];

    if (store == nil) {
        @throw [NSException exceptionWithName:@"KFData: Unable to load data store"
                                       reason:[error localizedDescription]
                                     userInfo:@{@"error":error}];
    }

    return store;
}

#pragma mark -

- (KFManagedObjectContext *)managedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    KFManagedObjectContext *context = [[KFManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [context setParentContext:[self managedObjectContext]];
    return context;
}

- (void)performReadBlock:(void (^) (NSManagedObjectContext* managedObjectContext))readBlock {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

    [managedObjectContext performBlock:^{
        readBlock(managedObjectContext);
    }];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure
{
    NSManagedObjectContext *context = [self managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

    [context performWriteBlock:^(NSManagedObjectContext *managedObjectContext) {
        writeBlock(managedObjectContext);
    } success:success failure:failure];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock {
    [self performWriteBlock:writeBlock success:nil failure:nil];
}

- (void)performWriteBlockOnMainManagedObjectContext:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock
                                  completionHandler:(void (^)(void))completionHandler
{
    [[self managedObjectContext] performWriteBlock:^(NSManagedObjectContext *managedObjectContext) {
        writeBlock([self managedObjectContext]);
    } success:completionHandler failure:^(__unused NSError *error) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

@end
