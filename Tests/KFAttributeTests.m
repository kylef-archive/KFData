//
//  KFAttributeTests
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//  Copyright 2012-2013  Kyle Fuller. All rights reserved.
//

#import "KFDataTests.h"


@interface KFAttributeTests : XCTestCase

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

- (void)testCreateEqualPredicateWithOptions {
    expect([[self attribute] equal:@4 options:NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id ==[c] 4"]);
}

- (void)testCreateUnequalPredicate {
    expect([[self attribute] notEqual:@4]).to.equal([NSPredicate predicateWithFormat:@"id != 4"]);
}

- (void)testCreateUnequalPredicateWithOptions {
    expect([[self attribute] notEqual:@4 options:NSDiacriticInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id !=[d] 4"]);
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

- (void)testIsNilPredicate {
    expect([[self attribute] isNil]).to.equal([NSPredicate predicateWithFormat:@"id == nil"]);
}

- (void)testIsYesPredicate {
    expect([[self attribute] isYes]).to.equal([NSPredicate predicateWithFormat:@"id == YES"]);
}

- (void)testIsNoPredicate {
    expect([[self attribute] isNo]).to.equal([NSPredicate predicateWithFormat:@"id == NO"]);
}

- (void)testLikePredicate {
    expect([[self attribute] like:@4]).to.equal([NSPredicate predicateWithFormat:@"id LIKE 4"]);
}

- (void)testLikePredicateWithOptions {
    expect([[self attribute] like:@4 options:NSDiacriticInsensitivePredicateOption | NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id LIKE[cd] 4"]);
}

- (void)testMatchesPredicate {
    expect([[self attribute] matches:@4]).to.equal([NSPredicate predicateWithFormat:@"id MATCHES 4"]);
}

- (void)testPredicateWithOptions {
    expect([[self attribute] matches:@4 options:NSDiacriticInsensitivePredicateOption | NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id MATCHES[cd] 4"]);
}

- (void)testBeginsWithPredicate {
    expect([[self attribute] beginsWith:@4]).to.equal([NSPredicate predicateWithFormat:@"id BEGINSWITH 4"]);
}

- (void)testBeginsWithPredicateWithOptions {
    expect([[self attribute] beginsWith:@4 options:NSDiacriticInsensitivePredicateOption | NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id BEGINSWITH[cd] 4"]);
}

- (void)testEndsWithPredicate {
    expect([[self attribute] endsWith:@4]).to.equal([NSPredicate predicateWithFormat:@"id ENDSWITH 4"]);
}

- (void)testEndsWithPredicateWithOptions {
    expect([[self attribute] endsWith:@4 options:NSDiacriticInsensitivePredicateOption | NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id ENDSWITH[cd] 4"]);
}

- (void)testBetweenPredicate {
    expect([[[self attribute] between:@1 and:@6] description]).to.equal(@"id BETWEEN {1, 6}");
}

- (void)testInPredicate {
    NSArray *contains = @[@1, @3];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", contains];

    expect([self.attribute in:contains]).to.equal(predicate);
}

- (void)testContainsPredicateWithOptions {
    expect([[self attribute] contains:@4 options:NSDiacriticInsensitivePredicateOption | NSCaseInsensitivePredicateOption]).to.equal([NSPredicate predicateWithFormat:@"id CONTAINS[cd] 4"]);
}

- (void)testContainsPredicate {
    expect([[self attribute] contains:@4]).to.equal([NSPredicate predicateWithFormat:@"id CONTAINS 4"]);
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
