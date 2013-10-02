//
//  NSManagedObjectContext+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObjectContext+KFData.h"


@implementation NSManagedObjectContext (KFData)

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    NSParameterAssert(writeBlock != nil);

    [self performBlock:^{
        writeBlock(self);

        if ([self hasChanges]) {
            NSError *error;
            if ([self save:&error]) {
                if (success) {
                    success();
                }
            } else if (failure) {
                failure(error);
            }
        }
    }];
}

@end
