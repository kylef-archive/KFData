//
//  KFDataStore.m
//  KFData
//
//  Created by Kyle Fuller on 20/10/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataStore.h"

@interface KFDataStore ()
@property (nonatomic) id currentUbiquityIdentityToken;

@property (nonatomic) NSPersistentStore *localPersistentStore;
@property (nonatomic) NSPersistentStore *cloudPersistentStore;
@property (nonatomic) NSPersistentStore *fallbackPersistentStore;

#define kKFDataStoreLocalConfig @"LocalConfig"
#define kKFDataStoreCloudConfig @"CloudConfig"

#define kKFDataStoreLocalFilename @"localStore.sqlite"
#define kKFDataStoreCloudFilename @"cloudStore.sqlite"
#define kKFDataStoreFallbackFilename @"fallbackStore.sqlite"
@end

@implementation KFDataStore

- (id)initWithManagedObjectModel:(NSManagedObjectModel*)managedObjectModel {
    if (self = [super init]) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager respondsToSelector:@selector(ubiquityIdentityToken)]) {
            id ubiquityIdentityToken = [fileManager ubiquityIdentityToken];
            [self setCurrentUbiquityIdentityToken:ubiquityIdentityToken];
        } else {
            NSLog(@"KFData doesn't yet support iCloud on iOS5");
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                @synchronized(self) {
//                    NSURL *ubiquityIdentityToken = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//                    [self setCurrentUbiquityIdentityToken:ubiquityIdentityToken];
//                }
//
//                [self asyncLoadPersistentStores];
//            });
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(iCloudAccountAvailabilityChanged:)
                                                     name:NSUbiquityIdentityDidChangeNotification
                                                   object:nil];
    }

    return self;
}

- (id)init {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    if (self = [self initWithManagedObjectModel:managedObjectModel]) {
        [self asyncLoadPersistentStores];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)iCloudAccountAvailabilityChanged:(NSNotification*)notification {
    [self unloadCloudPersistentStores];

    id ubiquityIdentityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    [self setCurrentUbiquityIdentityToken:ubiquityIdentityToken];

    [self asyncLoadPersistentStores];
}

- (BOOL)isCloudAvailible {
#pragma message("iCloud isn't supported yet #7")
//    return [self currentUbiquityIdentityToken] != nil;
    return NO;
}

#pragma mark - Data model

- (BOOL)hasLocalConfig {
    NSManagedObjectModel *managedObjectModel = [[self persistentStoreCoordinator] managedObjectModel];
    NSArray *configurations = [managedObjectModel configurations];

    return ([configurations indexOfObject:kKFDataStoreLocalConfig] != NSNotFound);
}

- (BOOL)hasCloudConfig {
    NSManagedObjectModel *managedObjectModel = [[self persistentStoreCoordinator] managedObjectModel];
    NSArray *configurations = [managedObjectModel configurations];
    
    return ([configurations indexOfObject:kKFDataStoreCloudConfig] != NSNotFound);
}

#pragma mark - Persistent stores

- (NSURL*)storesDirectoryURL {
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

- (NSURL*)localStoreURL {
    NSURL *storesDirectoryURL = [self storesDirectoryURL];
    NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:kKFDataStoreLocalFilename];
    
    return storeURL;
}

#pragma message("Support cloud persistent stores #7")
- (NSURL*)cloudStoreURL {
    return nil;
}

- (NSURL*)cloudDataURL {
    return nil;
}

- (NSURL*)fallbackStoreURL {
    NSURL *storesDirectoryURL = [self storesDirectoryURL];
    NSURL *storeURL = [storesDirectoryURL URLByAppendingPathComponent:kKFDataStoreFallbackFilename];

    return storeURL;
}

- (void)asyncLoadPersistentStores {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(self) {
            NSError *error;

            BOOL hasLocalStorage = [self hasLocalConfig];
            if (hasLocalStorage) {
                if ([self loadLocalPersistentStore:&error] == NO) {
                    NSLog(@"KFData: Failed to load local persistent store: %@", error);
                }
            }

            BOOL hasCloudStorage = [self hasCloudConfig];
            if (hasCloudStorage) {
                if ([self isCloudAvailible]) {
                    if ([self loadCloudPersistentStore:&error] == NO) {
                        NSLog(@"KFData: Failed to load cloud persistent store: %@", error);
                    }
                } else {
                    if ([self loadFallbackPersistentStore:&error] == NO) {
                        NSLog(@"KFData: Failed to load fallback persistent store: %@", error);
                    }
                }
            }

            if (hasLocalStorage == NO && hasCloudStorage == NO) {
                NSLog(@"KFData: No local or cloud configs");
            }
        }
    });
}

- (void)unloadCloudPersistentStores {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    NSError *error;

    if ([self fallbackPersistentStore]) {
        if ([persistentStoreCoordinator removePersistentStore:[self fallbackPersistentStore]
                                                        error:&error]) {
            [self setFallbackPersistentStore:nil];
        } else {
            NSLog(@"KFData: Failed to remove fallback store: %@", error);
        }
    }

    if ([self cloudPersistentStore]) {
        if ([persistentStoreCoordinator removePersistentStore:[self cloudPersistentStore]
                                                        error:&error]) {
            [self setCloudPersistentStore:nil];
        } else {
            NSLog(@"KFData: Failed to remove iCloud store: %@", error);
        }
    }
}

- (BOOL)loadLocalPersistentStore:(NSError *__autoreleasing *)error {
    BOOL success = NO;

    if ([self localPersistentStore] == nil) {
        NSURL *localStoreURL = [self localStoreURL];

        if (localStoreURL) {
            NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];

            NSPersistentStore *localStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                     configuration:kKFDataStoreLocalConfig
                                                                                               URL:localStoreURL
                                                                                           options:nil
                                                                                             error:error];

            if (localStore) {
                [self setLocalPersistentStore:localStore];
                success = YES;
            }
        }
    } else {
        success = YES;
    }

    return success;
}

- (BOOL)loadCloudPersistentStore:(NSError *__autoreleasing *)error {
    BOOL success = NO;

    if ([self cloudPersistentStore] == nil) {
        NSURL *cloudStoreURL = [self cloudStoreURL];
        NSURL *cloudDataURL = [self cloudDataURL];

        if (cloudStoreURL && cloudDataURL) {
            NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
            NSDictionary *persistentStoreOptions = @{
                NSPersistentStoreUbiquitousContentNameKey:@"iCloudStore",
                NSPersistentStoreUbiquitousContentURLKey:cloudDataURL,
            };

            NSPersistentStore *cloudStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                     configuration:kKFDataStoreCloudConfig
                                                                                               URL:cloudStoreURL
                                                                                           options:persistentStoreOptions
                                                                                             error:error];

            if (cloudStore) {
                [self setCloudPersistentStore:cloudStore];
                success = YES;
            }
        }
    } else {
        success = YES;
    }

    return success;
}

- (BOOL)loadFallbackPersistentStore:(NSError *__autoreleasing *)error {
    BOOL success = YES;

    if ([self fallbackPersistentStore] == nil) {
        NSURL *fallbackStoreURL = [self fallbackStoreURL];

        NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
        NSPersistentStore *fallbackStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                    configuration:kKFDataStoreCloudConfig
                                                                                              URL:fallbackStoreURL
                                                                                          options:nil
                                                                                            error:error];

        if (fallbackStore) {
            [self setFallbackPersistentStore:fallbackStore];
        } else {
            success = NO;
        }
    }

    return success;
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
       completionHandler:(void(^)(void))completionHandler {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

    [managedObjectContext performBlock:^{
        writeBlock(managedObjectContext);

        [managedObjectContext nestedSave];

        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext* managedObjectContext))writeBlock {
    [self performWriteBlock:writeBlock completionHandler:nil];
}

@end
