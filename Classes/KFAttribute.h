//
//  KFAttribute.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>

@interface KFAttribute : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSString *key;

+ (instancetype)attributeWithKey:(NSString *)key;

- (NSExpression *)expression;

- (NSSortDescriptor *)ascending;
- (NSSortDescriptor *)descending;

- (NSPredicate *)equal:(id)value;
- (NSPredicate *)notEqual:(id)value;

@end
