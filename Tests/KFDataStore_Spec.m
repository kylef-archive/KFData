//
//  KFDataStore_Spec.m
//  KFData
//
//  Created by Kyle Fuller on 13/02/2013.
//  Copyright 2013 KFData. All rights reserved.
//

#import "Kiwi.h"
#import "KFDataStore.h"


SPEC_BEGIN(KFDataStore_Spec)

describe(@"KFDataStore", ^{
    context(@"a newly created data store", ^{
        __block KFDataStore *dataStore;

        beforeEach(^{
            dataStore = [[KFDataStore alloc] init];
        });

        context(@"with a managed object context", ^{
            __block NSManagedObjectContext *managedObjectContext;

            beforeEach(^{
                managedObjectContext = [dataStore managedObjectContext];
            });

            it(@"should be of the private queue type", ^{
                [[theValue([managedObjectContext concurrencyType]) should] equal:theValue(NSPrivateQueueConcurrencyType)];
            });

            it(@"should shared a persistent store coordinator", ^{
                NSPersistentStoreCoordinator *persistentStoreCoordinator = [managedObjectContext persistentStoreCoordinator];
                [[[managedObjectContext persistentStoreCoordinator] should] equal:persistentStoreCoordinator];;
            });
        });

        it(@"should have a persistent store coordinator", ^{
            [[[dataStore persistentStoreCoordinator] should] beNonNil];
        });
    });

    context(@"an in-memory store", ^{
        __block KFDataStore *dataStore;

        beforeEach(^{
            dataStore = [KFDataStore standardMemoryDataStore];
        });

        it(@"should have an in-memory persistent store", ^{
            [[dataStore managedObjectContext] performBlockAndWait:^{
                NSPersistentStore *persistentStore = [[[dataStore persistentStoreCoordinator] persistentStores] lastObject];
                [[[persistentStore type] should] equal:NSInMemoryStoreType];
            }];
        });
    });

    context(@"an local store", ^{
        __block KFDataStore *dataStore;

        beforeEach(^{
            dataStore = [KFDataStore standardLocalDataStore];
        });

        it(@"should have a local persistent store", ^{
            [[dataStore managedObjectContext] performBlockAndWait:^{
                NSPersistentStore *persistentStore = [[[dataStore persistentStoreCoordinator] persistentStores] lastObject];
                [[[persistentStore type] should] equal:NSSQLiteStoreType];
            }];
        });
    });
});

SPEC_END
