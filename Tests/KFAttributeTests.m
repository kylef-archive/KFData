//
//  KFAttributeTests
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//  Copyright 2012-2013  Kyle Fuller. All rights reserved.
//

#import "KFDataTests.h"


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

- (void)testExpression {
    expect([[self attribute] expression]).to.equal([NSExpression expressionForKeyPath:@"id"]);
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

- (void)testGreaterThanPredicate {
    expect([[self attribute] greaterThan:@4]).to.equal([NSPredicate predicateWithFormat:@"id > 4"]);
}

- (void)testGreaterThanOrEqualToPredicate {
    expect([[self attribute] greaterThanOrEqualTo:@4]).to.equal([NSPredicate predicateWithFormat:@"id >= 4"]);
}

- (void)testLessThanPredicate {
    expect([[self attribute] lessThan:@4]).to.equal([NSPredicate predicateWithFormat:@"id < 4"]);
}

- (void)testLessThanOrEqualToPredicate {
    expect([[self attribute] lessThanOrEqualTo:@4]).to.equal([NSPredicate predicateWithFormat:@"id <= 4"]);
}

- (void)testPredicateFromFormat {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == 4", [self attribute]];
    expect([predicate description]).to.equal([[NSPredicate predicateWithFormat:@"id == 4"] description]);
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

- (void)testEquality {
    KFAttribute *attribute = [KFAttribute attributeWithKey:@"id"];
    expect(attribute).to.equal([self attribute]);
}

- (void)testInequality {
    expect([self attribute]).notTo.equal(@"id");
}

- (void)testHash {
    KFAttribute *attribute = [KFAttribute attributeWithKey:@"id"];
    expect([[self attribute] hash]).to.equal([attribute hash]);
}

@end
