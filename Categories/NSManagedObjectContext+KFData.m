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

- (BOOL)nestedSave:(NSError **)error {
    BOOL hasChanges = [self hasChanges];

    __block BOOL saved = [self save:error];

    if (saved && hasChanges) {
        NSManagedObjectContext *parentContext = [self parentContext];

        [parentContext performBlockAndWait:^{
            saved = [parentContext nestedSave:error];
        }];
    }

    return saved;
}

- (void)nestedSaveSuccess:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure
{
    NSError *error;

    if ([self hasChanges]) {
        if ([self save:&error]) {
            NSManagedObjectContext *parentContext = [self parentContext];

            if (parentContext) {
                [parentContext performNestedSaveSuccess:success failure:failure];
            } else if (success) {
                success();
            }
        } else if (failure) {
            failure(error);
        }
    } else if (success) {
        success();
    }
}

- (void)performNestedSaveSuccess:(void(^)(void))success
                         failure:(void(^)(NSError *error))failure
{
    [self performBlock:^{
        [self nestedSaveSuccess:success failure:failure];
    }];
}

#pragma mark -

- (void)performWriteBlock:(void(^)(void))writeBlock {
    [self performWriteBlock:writeBlock success:nil failure:^(NSError *error) {
        if (error) {
            @throw [NSException exceptionWithName:@"KFData performWriteBlock error"
                                           reason:[error localizedDescription]
                                         userInfo:@{@"error":error}];
        }
    }];
}

- (void)performWriteBlock:(void(^)(void))writeBlock
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure
{
    [self performBlock:^{
        writeBlock();
        [self nestedSaveSuccess:success failure:failure];
    }];
}

@end

