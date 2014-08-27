//
//  KFDataTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewController.h"
#import "KFDataTableViewDataSource.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

@implementation KFDataTableViewController

#pragma mark -

- (Class)dataSourceClass {
    return [KFDataTableViewDataSource class];
}

- (void)setDataSource:(KFDataTableViewDataSource *)dataSource {
    if (dataSource) {
        NSParameterAssert(dataSource.tableView == self.tableView);
    }

    if (dataSource.cellForManagedObject == nil) {
        __weak KFDataTableViewController *weakViewController = self;
        dataSource.cellForManagedObject = (^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath, NSManagedObject *managedObject) {
            return [weakViewController tableView:tableView cellForManagedObject:managedObject atIndexPath:indexPath];
        });
    }

    _dataSource = dataSource;

    NSError *error;
    if ([self performFetch:&error] == NO) {
        NSString *reason = [NSString stringWithFormat:@"%@: Problem performing fetch (%@)", NSStringFromClass([self class]), [error localizedDescription]];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:@{ NSUnderlyingErrorKey: error }];
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    self.dataSource = [[[self dataSourceClass] alloc] initWithTableView:self.tableView managedObjectContext:managedObjectContext fetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
}

- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    self.dataSource = [[[self dataSourceClass] alloc] initWithTableView:self.tableView objectManager:objectManager sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
}

- (BOOL)performFetch:(NSError **)error {
    return [_dataSource performFetch:error];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reason = [NSString stringWithFormat:@"%@: You must override %@ or %@", NSStringFromClass([self class]), NSStringFromSelector(@selector(tableView:cellForManagedObject:atIndexPath:)), NSStringFromSelector(@selector(tableView:cellForRowAtIndexPath:))];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

#endif
