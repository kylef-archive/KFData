//
//  KFObjectManagerTests
//  KFDataTests
//
//  Created by Kyle Fuller on 14/06/2013.
//
//

#import "KFDataTests.h"


@interface KFObjectManagerTests : XCTestCase

@end

@implementation KFObjectManagerTests

- (void)testInitRaisesException {
    expect(^{ (void)[[KFObjectManager alloc] init]; }).to.raiseAny();
}

- (void)testCreation {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    expect(objectManager).notTo.beNil();
    expect([objectManager managedObjectContext]).to.equal(managedObjectContext);
    expect([objectManager entityDescription]).to.equal(entityDescription);
    expect([objectManager predicate]).to.beNil();
    expect([objectManager sortDescriptors]).to.equal(@[]);
}

- (void)testCreationWithPredicateAndSortDescriptors {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];

    expect(objectManager).notTo.beNil();
    expect([objectManager managedObjectContext]).to.equal(managedObjectContext);
    expect([objectManager entityDescription]).to.equal(entityDescription);
    expect([objectManager predicate]).to.equal(predicate);
    expect([objectManager sortDescriptors]).to.equal(sortDescriptors);
}

- (void)testCreationWithPredicateAndSortDescriptorsCreatesCopy {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];

    // for some reason, copy on an NSArray isn't actually a copy
    NSArray *sortDescriptors = [@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]] mutableCopy];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];

    expect([objectManager predicate]).notTo.beIdenticalTo(predicate);
    expect([objectManager sortDescriptors]).notTo.beIdenticalTo(sortDescriptors);
    expect([objectManager predicate]).to.equal(predicate);
    expect([objectManager sortDescriptors]).to.equal(sortDescriptors);
}

- (void)testCreationFromFetchRequest {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];

    KFObjectManager *manager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext fetchRequest:fetchRequest];
    expect([manager managedObjectContext]).to.equal(managedObjectContext);
    expect([manager predicate]).to.equal(predicate);
    expect([manager sortDescriptors]).to.equal(sortDescriptors);
    expect([manager entityDescription]).to.equal(entityDescription);
}

- (void)testIsEqual {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];

    // for some reason, copy on an NSArray isn't actually a copy
    NSArray *sortDescriptors = [@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]] mutableCopy];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];
    KFObjectManager *identicalObjectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];

    expect(objectManager).to.equal(identicalObjectManager);
    expect([objectManager hash]).to.equal([identicalObjectManager hash]);
}

- (void)testCopying {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];
    KFObjectManager *copiedManager = [objectManager copy];

    expect(copiedManager).to.equal(objectManager);
}

- (void)testFilterSetsPredicate {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    KFObjectManager *newObjectManager = [objectManager filter:predicate];

    expect([newObjectManager predicate]).to.equal(predicate);
}

- (void)testExcludeSetsPredicate {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    KFObjectManager *newObjectManager = [objectManager exclude:predicate];

    expect([newObjectManager predicate]).to.equal([NSPredicate predicateWithFormat:@"NOT name == 'Kyle'"]);
}

- (void)testFilterAddsPredicate {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    KFObjectManager *newObjectManager = [objectManager filter:namePredicate];

    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"username == 'kylef'"];
    KFObjectManager *finalObjectManager = [newObjectManager filter:usernamePredicate];

    expect([finalObjectManager predicate]).to.equal([NSPredicate predicateWithFormat:@"name == 'Kyle' AND username == 'kylef'"]);
}

- (void)testExcludeAddsPredicate {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    KFObjectManager *newObjectManager = [objectManager filter:namePredicate];

    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"username == 'kylef'"];
    KFObjectManager *finalObjectManager = [newObjectManager exclude:usernamePredicate];

    expect([finalObjectManager predicate]).to.equal([NSPredicate predicateWithFormat:@"(name == 'Kyle') AND NOT (username == 'kylef')"]);
}

- (void)testOrderBy {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    KFObjectManager *newObjectManager = [objectManager orderBy:sortDescriptors];

    expect([newObjectManager sortDescriptors]).to.equal(sortDescriptors);
}

- (void)testReverse {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription];

    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]];
    KFObjectManager *newObjectManager = [objectManager orderBy:sortDescriptors];
    KFObjectManager *finalObjectManager = [newObjectManager reverse];

    NSArray *reversedSortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]
    ];

    expect([finalObjectManager sortDescriptors]).to.equal(reversedSortDescriptors);
}

- (void)testFetchRequest {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == YES"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    KFObjectManager *objectManager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];
    NSFetchRequest *fetchRequest = [objectManager fetchRequest];

    expect([fetchRequest entityName]).to.equal([entityDescription name]);
    expect([fetchRequest predicate]).to.equal(predicate);
    expect([fetchRequest sortDescriptors]).to.equal(sortDescriptors);
}

@end
