//
//  KFDataTableViewDataSourceTests.m
//  KFDataTests
//
//  Created by Kyle Fuller on 24/09/2013.
//
//

#import "KFDataTests.h"
#import <KFData/UI/KFDataTableViewDataSource.h>
#import <KFData/KFObjectManager.h>


@interface KFDataTableViewDataSourceTests : SenTestCase {
    UITableView *_tableView;
    NSManagedObjectContext *_managedObjectContext;
    NSFetchRequest *_fetchRequest;
    KFObjectManager *_objectManager;
    KFDataTableViewDataSource *_dataSource;
}

@end

@implementation KFDataTableViewDataSourceTests

- (void)setUp {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    _tableView = [[UITableView alloc] init];
    _fetchRequest = [[NSFetchRequest alloc] init];
    [_fetchRequest setSortDescriptors:sortDescriptors];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:_managedObjectContext];
    _objectManager = [KFObjectManager managerWithManagedObjectContext:_managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:sortDescriptors];

    _dataSource = [[KFDataTableViewDataSource alloc] initWithTableView:_tableView managedObjectContext:_managedObjectContext fetchRequest:_fetchRequest sectionNameKeyPath:nil cacheName:nil cellHandler:^UITableViewCell *(KFDataTableViewDataSource *dataSource, NSIndexPath *indexPath, NSManagedObject *managedObject) {
        return nil;
    }];
}

- (void)testInitSetTableViewDataSource {
    expect([_tableView dataSource]).to.equal(_dataSource);
}

- (void)testInitSetsTableView {
    expect([_dataSource tableView]).to.equal(_tableView);
}

- (void)testInitSetsFetchRequest {
    expect([_dataSource fetchRequest]).to.equal(_fetchRequest);
}

- (void)testInitSetsManagedObjectContext {
    expect([_dataSource managedObjectContext]).to.equal(_managedObjectContext);
}

- (void)testInitWithManagerSetsManagedObjectContext {
    KFDataTableViewDataSource *dataSource = [[KFDataTableViewDataSource alloc] initWithTableView:_tableView objectManager:_objectManager sectionNameKeyPath:nil cacheName:nil cellHandler:^UITableViewCell *(KFDataTableViewDataSource *dataSource, NSIndexPath *indexPath, NSManagedObject *managedObject) {
        return nil;
    }];
    expect([dataSource managedObjectContext]).to.equal(_managedObjectContext);
}

@end
