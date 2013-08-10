//
//  KFManagedObjectContext.m
//  KFData
//
//  Created by Kyle Fuller on 11/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "KFManagedObjectContext.h"

@implementation KFManagedObjectContext

#pragma mark - Setters

- (void)setParentContext:(NSManagedObjectContext *)parentContext {
    if ([self mergeFromParentContext]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

        NSManagedObjectContext *oldParent = [self parentContext];
        if (oldParent) {
            [notificationCenter removeObserver:self
                                          name:NSManagedObjectContextDidSaveNotification
                                        object:oldParent];
        }

        if (parentContext) {
            [notificationCenter addObserver:self
                                   selector:@selector(mergeChanges:)
                                       name:NSManagedObjectContextDidSaveNotification
                                     object:parentContext];
        }
    }

    [super setParentContext:parentContext];
}

- (void)setMergeFromParentContext:(BOOL)mergeFromParentContext {
    if (mergeFromParentContext != _mergeFromParentContext) {
        _mergeFromParentContext = mergeFromParentContext;

        NSManagedObjectContext *parentContext = [self parentContext];
        if (parentContext) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

            if (mergeFromParentContext) {
                [notificationCenter addObserver:self
                                       selector:@selector(mergeChanges:)
                                           name:NSManagedObjectContextDidSaveNotification
                                         object:parentContext];
            } else {
                [notificationCenter removeObserver:self
                                              name:NSManagedObjectContextDidSaveNotification
                                            object:parentContext];
            }
        }
    }
}

- (void)dealloc {
    NSManagedObjectContext *parentContext = [self parentContext];
    if (parentContext && [self mergeFromParentContext]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

        [notificationCenter removeObserver:self
                                      name:NSManagedObjectContextDidSaveNotification
                                    object:parentContext];
    }
}

#pragma mark - Notifications

- (void)mergeChanges:(NSNotification*)notification {
    [self performBlock:^{
        [self mergeChangesFromContextDidSaveNotification:notification];
    }];
}

@end
