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

- (NSPredicate *)equal:(id)value;
- (NSPredicate *)notEqual:(id)value;

@end

@interface KFAttribute (Sorting)

- (NSSortDescriptor *)ascending;
- (NSSortDescriptor *)descending;

@end
