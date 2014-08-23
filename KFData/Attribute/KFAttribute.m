//
//  KFAttribute.m
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import "KFAttribute.h"

@implementation KFAttribute

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
    return [[KFAttribute alloc] initWithName:key];
}

+ (instancetype)attributeWithKey:(NSString *)key {
    return [[KFAttribute alloc] initWithName:key];
}

- (NSString *)key {
    return self.name;
}

@end
