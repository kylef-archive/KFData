//
//  KFDataTableViewControllerTests.m
//  KFDataTests
//
//  Created by Kyle Fuller on 09/06/2013.
//
//

#import "KFDataTests.h"
#import "KFDataTableViewController.h"


@interface KFDataTableViewControllerTests : SenTestCase

@end

@implementation KFDataTableViewControllerTests

- (void)testInitRaisesException {
    expect(^{ (void)[[KFDataTableViewController alloc] init]; }).to.raiseAny();
}

- (void)testInitWithManagedObjectContextSetsProperty {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    KFDataTableViewController *tableViewController = [[KFDataTableViewController alloc] initWithManagedObjectContext:managedObjectContext];
    expect([tableViewController managedObjectContext]).to.beIdenticalTo(managedObjectContext);
}

@end
