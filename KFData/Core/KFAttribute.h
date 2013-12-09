//
//  KFAttribute.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>

/** A helper class to generate predicates and sort descriptors for attributes
 on a managed object.
 */


#define KFAttributeFromKey(KEY) [KFAttribute attributeWithKey:(NSStringFromSelector(@selector(KEY)))]

@interface KFAttribute : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly) NSString *key;

+ (instancetype)attributeWithKey:(NSString *)key __attribute((nonnull));

/** Returns a Boolean value that indicates whether a given attribute is equal to the receiver
 @param attribute The attribute to compare against the receiver
 @return YES if attribute is equivalent to the receiver
 */
- (BOOL)isEqualToAttribute:(KFAttribute *)attribute;

/** Returns an expression for the attributes key-value path */
- (NSExpression *)expression;

@end

@interface KFAttribute (Predicate)

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see notEqual:
 */
- (NSPredicate *)equal:(id)value;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see equal:
 */
- (NSPredicate *)notEqual:(id)value;

/** Returns a predicate for greater than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThanOrEqualTo:
 */
- (NSPredicate *)greaterThan:(id)value;

/** Returns a predicate for greater than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThan:
 */
- (NSPredicate *)greaterThanOrEqualTo:(id)value;

/** Returns a predicate for less than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThanOrEqualTo:
 */
- (NSPredicate *)lessThan:(id)value;

/** Returns a predicate for less than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThan:
 */
- (NSPredicate *)lessThanOrEqualTo:(id)value;

@end

@interface KFAttribute (Sorting)

/** Returns an ascending sort descriptor for this attribute */
- (NSSortDescriptor *)ascending;

/** Returns a descending sort descriptor for this attribute */
- (NSSortDescriptor *)descending;

@end
