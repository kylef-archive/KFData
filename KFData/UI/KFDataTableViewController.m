//
//  KFDataTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataStore.h"
#import "KFDataTableViewDataSource.h"


@interface KFDataTableViewController ()

//@property (nonatomic, strong) KFDataTableViewDataSource *dataSource;

@end

@implementation KFDataTableViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSError *error;
    if ([self dataSource] && ([self performFetch:&error] == NO)) {
        NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
    }
}

#pragma mark -

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    __weak KFDataTableViewController *controller = self;

    _dataSource = [[KFDataTableViewDataSource alloc] initWithTableView:[self tableView] managedObjectContext:managedObjectContext fetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName cellHandler:^UITableViewCell *(KFDataTableViewDataSource *dataSource, NSIndexPath *indexPath, NSManagedObject *managedObject) {
        return [controller dataSource:dataSource cellForManagedObject:managedObject atIndexPath:indexPath];
    }];

    if ([self isViewLoaded]) {
        NSError *error;
        if ([self performFetch:&error] == NO) {
            NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
        }
    }
}

- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    __weak KFDataTableViewController *controller = self;

    _dataSource = [[KFDataTableViewDataSource alloc] initWithTableView:[self tableView] objectManager:objectManager sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName cellHandler:^UITableViewCell *(KFDataTableViewDataSource *dataSource, NSIndexPath *indexPath, NSManagedObject *managedObject) {
        return [controller dataSource:dataSource cellForManagedObject:managedObject atIndexPath:indexPath];
    }];

    if ([self isViewLoaded]) {
        NSError *error;
        if ([self performFetch:&error] == NO) {
            NSLog(@"KFDataTableViewController: Error performing fetch %@", error);
        }
    }
}

- (BOOL)performFetch:(NSError **)error {
    return [_dataSource performFetch:error];
}

- (UITableViewCell *)dataSource:(KFDataTableViewDataSource *)dataSource cellForManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"dataSource:cellForManagedObject: must be overidden." userInfo:nil];
}

@end

#endif
