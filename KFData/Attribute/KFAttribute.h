//
//  KFAttribute.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>
#import <QueryKit/QueryKit.h>

#define KFAttributeFromKey(NAME) [[KFAttribute alloc] initWithName:(NSStringFromSelector(@selector(NAME)))]

/** A helper class to generate predicates and sort descriptors for attributes
 on a managed object.
 
 @note This class is provided for legacy reasons and has been moved to QKAttribute.
 */
@interface KFAttribute : QKAttribute

@property (nonatomic, strong, readonly) NSString *key __deprecated;

/// Returns an attribute from multiple other attributes
+ (instancetype)attributeWithAttributes:(KFAttribute *)attribute, ... NS_REQUIRES_NIL_TERMINATION __deprecated;

/// Returns an attribute with key
+ (instancetype)attributeWithKey:(NSString *)key __attribute((nonnull)) __deprecated;

@end
