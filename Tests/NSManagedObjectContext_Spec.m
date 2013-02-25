//
//  NSManagedObjectContext_Spec.m
//  KFData
//
//  Created by Kyle Fuller on 15/02/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Kiwi.h"
#import "NSManagedObjectContext+KFData.h"

SPEC_BEGIN(NSManagedObjectContext_Spec)

describe(@"NSManagedObjectContext KFData extensions", ^{
    context(@"a managed object context", ^{
        __block NSManagedObjectContext *managedObjectContext;

        beforeEach(^{
            managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        });

        it(@"should run block", ^{
            __block BOOL isWriteBlockExecuted = NO;

            [[[managedObjectContext should] receive] nestedSave:nil];

            [managedObjectContext performWriteBlock:^{
                isWriteBlockExecuted = YES;
            }];

            [managedObjectContext performBlockAndWait:^{
                [[theValue(isWriteBlockExecuted) should] beTrue];
            }];
        });

        context(@"has a child context", ^{
            __block NSManagedObjectContext *childContext;

            beforeEach(^{
                childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [childContext setParentContext:managedObjectContext];
            });

            it(@"should save up to parent", ^{
                [[[managedObjectContext should] receive] nestedSave:nil];
                [[[childContext should] receiveAndReturn:theValue(YES)] hasChanges];

                [childContext nestedSave:nil];
            });
        });
    });
});

SPEC_END
