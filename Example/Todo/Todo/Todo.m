//
//  Todo.m
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "Todo.h"


@implementation Todo

+ (KFAttribute *)created {
    return [KFAttribute attributeWithKey:@"created"];
}

@dynamic name;
@dynamic complete;
@dynamic created;

@end
