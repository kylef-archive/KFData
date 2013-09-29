//
//  KFAttribute.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>

@interface KFAttribute : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly) NSString *key;

+ (instancetype)attributeWithKey:(NSString *)key;

/** Returns a Boolean value that indicates whether a given attribute is equal to the receiver
 @param attribute The attribute to compare against the receiver
 @return YES if attribute is equivalent to the receiver
 */
- (BOOL)isEqualToAttribute:(KFAttribute *)attribute;

- (NSExpression *)expression;

@end

@interface KFAttribute (Predicate)

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)equal:(id)value;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)notEqual:(id)value;

/** Returns a predicate for greater than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)greaterThan:(id)value;

/** Returns a predicate for greater than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)greaterThanOrEqualTo:(id)value;

/** Returns a predicate for less than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)lessThan:(id)value;

/** Returns a predicate for less than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 */
- (NSPredicate *)lessThanOrEqualTo:(id)value;

@end

@interface KFAttribute (Sorting)

- (NSSortDescriptor *)ascending;
- (NSSortDescriptor *)descending;

@end
