//
//  KFDataViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataStore.h"
#import "KFDataViewController.h"

@interface KFDataViewController ()

@end

@implementation KFDataViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    if (self = [self init]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

@end

#endif
