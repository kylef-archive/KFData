//
//  NSManagedObjectContext+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObjectContext+KFData.h"


@implementation NSManagedObjectContext (KFData)

- (void)performWriteBlock:(void(^)(void))writeBlock completion:(void(^)(NSError *error))completion {
    NSParameterAssert(writeBlock != nil);

    [self performBlock:^{
        writeBlock();

        if ([self hasChanges]) {
            NSError *error;
            if ([self save:&error]) {
                if (completion) {
                    completion(nil);
                }
            } else if (completion) {
                completion(error);
            }
        } else if (completion) {
            completion(nil);
        }
    }];
}

@end
