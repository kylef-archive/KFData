//
//  NSManagedObjectContext+KFDataCompatibility.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObjectContext+KFDataCompatibility.h"
#import "NSManagedObjectContext+KFData.h"


@implementation NSManagedObjectContext (KFDataCompatibility)

- (void)performWriteBlock:(void (^)(NSManagedObjectContext* managedObjectContext))writeBlock {
    [self performWriteBlock:^{
        writeBlock(self);
    } completion:nil];
}

- (void)performWriteBlock:(void(^)(NSManagedObjectContext *managedObjectContext))writeBlock success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    [self performWriteBlock:^{
        writeBlock(self);
    } completion:^(NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else if (success) {
            success();
        }
    }];
}

@end
