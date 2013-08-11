/* This is a private header for KFDataStore. */

#import "KFDataStore.h"


@interface KFDataSingleStackStoreBase : KFDataStore  // Abstract class

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundManagedObjectContext;

@end

@interface KFDataSingleStackStore : KFDataSingleStackStoreBase

@end

@interface KFDataSingleResetStackStore : KFDataSingleStackStoreBase

@end

@interface KFDataDualStackStoreBase : KFDataStore  // Abstract class

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *backgroundPersistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundManagedObjectContext;

@end

@interface KFDataDualStackStore : KFDataDualStackStoreBase

@end

@interface KFDataDualResetStackStore : KFDataDualStackStoreBase

@end

