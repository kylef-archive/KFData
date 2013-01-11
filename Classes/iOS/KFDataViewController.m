//
//  KFDataViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import "KFDataStore.h"
#import "NSManagedObjectContext+KFData.h"
#import "KFDataViewController.h"

@interface KFDataViewController ()

@end

@implementation KFDataViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    if (self = [self init]) {
        _managedObjectContext = managedObjectContext;

        NSManagedObjectContext *parentContext = [managedObjectContext parentContext];
        if (parentContext) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChanges:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:parentContext];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)mergeChanges:(NSNotification*)notification {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    [managedObjectContext performBlock:^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

@end
