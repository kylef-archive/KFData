//
// NSManagedObjectContext+KFData.m
// KFData
//
// Created by Kyle Fuller on 26/11/2012
// Copyright (c) 2012 Kyle Fuller. All rights reserved
//

#import "NSManagedObjectContext+KFData.h"

@implementation NSManagedObjectContext (KFData)

- (BOOL)save {
    BOOL saved = NO;

    if ([self hasChanges]) {
        NSError *error;

        @try {
            saved = [self save:&error];
        } @catch (NSException *exception) {
            NSLog(@"KFData - [NSManagedObjectContext save] (%@)", exception);
        }

        if (saved == NO) {
            NSLog(@"KFData - [NSManagedObjectContext save] (%@)", error);
        }
    }

    return saved;
}

- (BOOL)nestedSave {
    __block BOOL saved = [self save];

    if (saved) {
        NSManagedObjectContext *parentContext = [self parentContext];

        [parentContext performBlockAndWait:^{
            saved = [parentContext save];
        }];
    }

    return saved;
}

- (void)performSave {
    if ([self hasChanges]) {
        [self performBlock:^{
            BOOL saved = NO;
            NSError *error;
            
            @try {
                saved = [self save:&error];
            } @catch (NSException *exception) {
                NSLog(@"KFData - [NSManagedObjectContext save] (%@)", exception);
            }
            
            if (saved == NO) {
                NSLog(@"KFData - [NSManagedObjectContext save] (%@)", error);
            }
        }];
    }
}

- (void)performNestedSave {
    [self performBlock:^{
        if ([self save]) {
            NSManagedObjectContext *parentContext = [self parentContext];
            [parentContext performNestedSave];
        }
    }];
}

#pragma mark -

- (void)performWriteBlock:(void(^)(void))writeBlock {
    [self performBlock:^{
        writeBlock();
        [self save];
    }];
}

- (void)performWriteBlock:(void(^)(void))writeBlock
        completionHandler:(void(^)(void))completionHandler
{
    [self performBlock:^{
        writeBlock();

        [self save];

        if (completionHandler) {
            completionHandler();
        }
    }];
}

@end

