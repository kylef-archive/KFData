//
//  KFDataStore.m
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataStoreInternal.h"


NSString * const KFDataManagedObjectContextWillReset = @"KFDataManagedObjectContextWillReset";
NSString * const KFDataManagedObjectContextDidReset = @"KFDataManagedObjectContextDidReset";

static NSString * const kKFDataStoreLocalFilename = @"localStore.sqlite";
static NSString * const kKFDataStoreCloudFilename = @"cloudStore.sqlite";

@implementation KFDataStore

+ (instancetype)storeWithConfigurationType:(KFDataStoreConfigurationType)configurationType {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return [KFDataStore storeWithConfigurationType:configurationType managedObjectModel:managedObjectModel];
}

+ (instancetype)storeWithConfigurationType:(KFDataStoreConfigurationType)configurationType managedObjectModel:(NSManagedObjectModel*)managedObjectModel {
    KFDataStore *store;

    switch (configurationType) {
        case KFDataStoreConfigurationTypeSingleStack:
            store = [[KFDataSingleStackStore alloc] initWithManagedObjectModel:managedObjectModel];
            break;

        case KFDataStoreConfigurationTypeDualStack:
            store = [[KFDataDualStackStore alloc] initWithManagedObjectModel:managedObjectModel];
            break;

        case KFDataStoreConfigurationTypeSingleResetStack:
            store = [[KFDataSingleResetStackStore alloc] initWithManagedObjectModel:managedObjectModel];
            break;

        case KFDataStoreConfigurationTypeDualResetStack:
            store = [[KFDataDualResetStackStore alloc] initWithManagedObjectModel:managedObjectModel];
            break;
    }

    return store;
}

/** Determine the base URL for data stores, this creates the directory if it doesn't already exist
 @param error Output error if returned URL is nil
 @return store directory URL or nil if there was a failure creating the directory
 */
+ (NSURL *)storesDirectoryURL:(NSError **)error {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storesDirectoryURL = [[NSURL fileURLWithPath:documentsDirectory] URLByAppendingPathComponent:@"DataStores"];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[storesDirectoryURL path]] == NO) {
        BOOL createSuccess = [fileManager createDirectoryAtURL:storesDirectoryURL withIntermediateDirectories:YES attributes:nil error:error];

        if (createSuccess == NO) {
            storesDirectoryURL = nil;
        }
    }

    return storesDirectoryURL;
}

+ (instancetype)standardLocalDataStore:(NSError **)error {
    KFDataStore *dataStore = [KFDataStore storeWithConfigurationType:KFDataStoreConfigurationTypeDualStack];

    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption: @YES,
        NSInferMappingModelAutomaticallyOption: @YES,
    };

    if ([dataStore addLocalStore:kKFDataStoreLocalFilename configuration:nil options:options error:error] == nil) {
        dataStore = nil;
    }

    return dataStore;
}

+ (instancetype)standardMemoryDataStore:(NSError **)error {
    KFDataStore *dataStore = [KFDataStore storeWithConfigurationType:KFDataStoreConfigurationTypeSingleStack];

    if ([dataStore addMemoryStore:nil error:error] == nil) {
        dataStore = nil;
    }

    return dataStore;
}

+ (instancetype)standardCloudDataStore:(NSError **)error {
    KFDataStore *dataStore = [KFDataStore storeWithConfigurationType:KFDataStoreConfigurationTypeSingleStack];

    if ([dataStore addCloudStore:kKFDataStoreCloudFilename configuration:nil contentNameKey:@"cloudStore" error:error] == nil) {
        dataStore = nil;
    }

    return dataStore;
}

#pragma mark -

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    return [super init];
}

#pragma mark - Stores

- (NSPersistentStore *)addPersistentStoreWithType:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options error:(NSError **)error {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"addPersistentStoreWithType:configuration:URL:options:error: must be overidden." userInfo:nil];
}

- (NSPersistentStore *)addMemoryStore:(NSString *)configuration error:(NSError **)error {
    return [self addPersistentStoreWithType:NSInMemoryStoreType configuration:configuration URL:nil options:nil error:error];
}

- (NSPersistentStore *)addLocalStore:(NSString *)filename configuration:(NSString *)configuration options:(NSDictionary *)options error:(NSError **)error {
    NSURL *storesDirectoryURL = [KFDataStore storesDirectoryURL:error];
    NSPersistentStore *persistentStore;

    if (storesDirectoryURL) {
        NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:filename];
        persistentStore = [self addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:storeURL options:options error:error];
    }

    return persistentStore;
}

- (NSPersistentStore *)addCloudStore:(NSString *)filename configuration:(NSString *)configuration contentNameKey:(NSString *)contentNameKey error:(NSError **)error {
    NSParameterAssert(filename != nil);
    NSParameterAssert(contentNameKey != nil);

    NSPersistentStore *persistentStore;

    NSURL *storesDirectoryURL = [KFDataStore storesDirectoryURL:error];
    if (storesDirectoryURL) {
        NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:filename];

        NSDictionary *options = @{
            NSPersistentStoreUbiquitousContentNameKey: contentNameKey,
        };

        persistentStore = [self addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:storeURL options:options error:error];
    }

    return persistentStore;
}

#pragma mark -

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"persistentStoreCoordinator must be overidden." userInfo:nil];
}

- (NSManagedObjectContext *)managedObjectContext {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"managedObjectContext must be overidden." userInfo:nil];
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"backgroundManagedObjectContext must be overidden." userInfo:nil];
}

#pragma mark -

- (void)performReadBlock:(void (^) (NSManagedObjectContext *managedObjectContext))readBlock {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"performReadBlock: must be overidden." userInfo:nil];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock completion:(void(^)(NSError *error))completion {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"performWriteBlock:success:failure: must be overidden." userInfo:nil];
}

@end
