//
//  KFDataCollectionViewControllerTests.m
//  KFDataTests
//
//  Created by Kyle Fuller on 09/06/2013.
//
//

#import "KFDataTests.h"
#import "KFDataCollectionViewController.h"


@interface KFDataCollectionViewControllerTests : SenTestCase

@end

@implementation KFDataCollectionViewControllerTests

- (void)testInitRaisesException {
    expect(^{ (void)[[KFDataCollectionViewController alloc] init]; }).to.raiseAny();
}

- (void)testInitWithManagedObjectContextSetsProperty {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    KFDataCollectionViewController *collectionViewController = [[KFDataCollectionViewController alloc] initWithManagedObjectContext:managedObjectContext];
    expect([collectionViewController managedObjectContext]).to.beIdenticalTo(managedObjectContext);
}

@end
