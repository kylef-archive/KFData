//
//  KFAttribute.m
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import "KFAttribute.h"

@implementation KFAttribute

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self key] forKey:@"key"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *key = [decoder decodeObjectOfClass:[NSString class] forKey:@"key"];

    if (self = [self initWithKey:key]) {
    }

    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    NSString *key = [[self key] copyWithZone:zone];
    return [[self class] attributeWithKey:key];
}

#pragma mark -

+ (instancetype)attributeWithKey:(NSString *)key {
    return [[KFAttribute alloc] initWithKey:key];
}

- (instancetype)initWithKey:(NSString *)key {
    if (self = [super init]) {
        _key = key;
    }

    return self;
}

- (NSExpression *)expression {
    return [NSExpression expressionForKeyPath:[self key]];
}

#pragma mark - Sorting

- (NSSortDescriptor *)ascending {
    return [[NSSortDescriptor alloc] initWithKey:[self key] ascending:YES];
}

- (NSSortDescriptor *)descending {
    return [[NSSortDescriptor alloc] initWithKey:[self key] ascending:NO];
}

#pragma mark - Comparison

- (NSPredicate *)predicateWithRightExpression:(NSExpression *)expression
                                     modifier:(NSComparisonPredicateModifier)modifier
                                         type:(NSPredicateOperatorType)type
                                      options:(NSComparisonPredicateOptions)options
{
    NSExpression *leftExpression = [self expression];

    return [NSComparisonPredicate predicateWithLeftExpression:leftExpression
                                              rightExpression:expression
                                                     modifier:modifier
                                                         type:type
                                                      options:options];
}

- (NSPredicate *)equal:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)notEqual:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSNotEqualToPredicateOperatorType
                                      options:0];
}

@end
