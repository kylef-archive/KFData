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
    [encoder encodeObject:self.key forKey:@"key"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *key = [decoder decodeObjectOfClass:[NSString class] forKey:@"key"];

    if (self = [self initWithKey:key]) {
    }

    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    NSString *key = [self.key copyWithZone:zone];
    return [[self class] attributeWithKey:key];
}

#pragma mark -

+ (instancetype)attributeWithAttributes:(KFAttribute *)attribute, ... {
    NSParameterAssert(attribute != nil);

    NSMutableArray *attributes = [NSMutableArray arrayWithObject:attribute.key];

    va_list attributeList;
    va_start(attributeList, attribute);
    while ((attribute = va_arg(attributeList, id))) {
        [attributes addObject:attribute.key];
    }
    va_end(attributeList);

    NSString *key = [attributes componentsJoinedByString:@"."];
    return [[KFAttribute alloc] initWithKey:key];;
}

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
    return [NSExpression expressionForKeyPath:self.key];
}

#pragma mark - Equality

- (NSUInteger)hash {
    return [self.key hash];
}

- (BOOL)isEqualToAttribute:(KFAttribute *)attribute {
    return [self.key isEqualToString:[attribute key]];
}

- (BOOL)isEqual:(id)object {
    return object == self || ([object isKindOfClass:[KFAttribute class]] && [self isEqualToAttribute:object]);
}

#pragma mark -

// The following methods are implemented so that `[NSPredicate predicateWithFormat:@"%K", attribute]` will work

- (NSString *)description {
    return self.key;
}

- (NSRange)rangeOfString:(NSString *)aString {
    return [self.key rangeOfString:aString];
}

- (NSArray *)componentsSeparatedByString:(NSString *)separator {
    return [self.key componentsSeparatedByString:separator];
}

- (NSUInteger)length {
    return [self.key length];
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

@end

@implementation KFAttribute (Predicate)

- (NSPredicate *)equal:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)equal:(id)value {
    return [self equal:value options:0];
}

- (NSPredicate *)notEqual:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSNotEqualToPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)notEqual:(id)value {
    return [self notEqual:value options:0];
}

- (NSPredicate *)beginsWith:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSBeginsWithPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)beginsWith:(id)value {
    return [self beginsWith:value options:0];
}

- (NSPredicate *)endsWith:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEndsWithPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)endsWith:(id)value {
    return [self endsWith:value options:0];
}

- (NSPredicate *)like:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLikePredicateOperatorType
                                      options:options];
}

- (NSPredicate *)like:(id)value {
    return [self like:value options:0];
}

- (NSPredicate *)matches:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSMatchesPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)matches:(id)value {
    return [self matches:value options:0];
}

- (NSPredicate *)greaterThan:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSGreaterThanPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)greaterThanOrEqualTo:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSGreaterThanOrEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)lessThan:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLessThanPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)lessThanOrEqualTo:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLessThanOrEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)isNil {
    NSExpression *expression = [NSExpression expressionForConstantValue:nil];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)between:(id)minimumValue and:(id)maxiumValue {
    NSParameterAssert(minimumValue != nil);
    NSParameterAssert(maxiumValue != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:@[minimumValue, maxiumValue]];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSBetweenPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)in:(id<NSFastEnumeration>)set {
    NSParameterAssert(set != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:set];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSInPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)contains:(id)value options:(NSComparisonPredicateOptions)options {
    NSParameterAssert(value != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSContainsPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)contains:(id)value {
    return [self contains:value options:0];
}

- (NSPredicate *)isYes {
    NSExpression *expression = [NSExpression expressionForConstantValue:@YES];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)isNo {
    NSExpression *expression = [NSExpression expressionForConstantValue:@NO];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

@end

@implementation KFAttribute (Sorting)

- (NSSortDescriptor *)ascending {
    return [[NSSortDescriptor alloc] initWithKey:self.key ascending:YES];
}

- (NSSortDescriptor *)descending {
    return [[NSSortDescriptor alloc] initWithKey:self.key ascending:NO];
}

@end
