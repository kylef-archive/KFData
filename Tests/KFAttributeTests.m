//
//  KFAttributeTests
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//  Copyright 2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTests.h"
#import "KFAttribute.h"


@interface KFAttributeTests : SenTestCase

@property (nonatomic, strong) KFAttribute *attribute;

@end

@implementation KFAttributeTests

- (void)setUp {
    [self setAttribute:[KFAttribute attributeWithKey:@"id"]];
}

- (void)testKeyPropertySet {
    expect([[self attribute] key]).to.equal(@"id");
}

- (void)testCreatingAscendingSortDescriptor {
    expect([[self attribute] ascending]).to.equal([NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]);
}

- (void)testCreatingDescendingSortDescriptor {
    expect([[self attribute] descending]).to.equal([NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]);
}

- (void)testCreateEqualPredicate {
    expect([[self attribute] equal:@4]).to.equal([NSPredicate predicateWithFormat:@"id == 4"]);
}

- (void)testCreateUnqualPredicate {
    expect([[self attribute] notEqual:@4]).to.equal([NSPredicate predicateWithFormat:@"id != 4"]);
}

- (void)testNSCoding {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:[self attribute]];
    KFAttribute *codedAttribute = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];

    expect([codedAttribute key]).to.equal(@"id");
}

- (void)testCopying {
    KFAttribute *copiedAttribute = [[self attribute] copy];
    expect([copiedAttribute key]).to.equal(@"id");
}

@end
