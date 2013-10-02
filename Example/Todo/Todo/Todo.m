//
//  Todo.m
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "Todo.h"


@implementation Todo

+ (KFObjectManager *)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [super managerWithManagedObjectContext:managedObjectContext];

    return [manager orderBy:@[[[Todo created] ascending]]];
}

+ (KFObjectManager *)completedManagerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [[self managerWithManagedObjectContext:managedObjectContext] filter:[[self complete] equal:@YES]];
}

+ (KFAttribute *)name {
    return [KFAttribute attributeWithKey:@"name"];
}

+ (KFAttribute *)complete {
    return [KFAttribute attributeWithKey:@"complete"];
}

+ (KFAttribute *)created {
    return [KFAttribute attributeWithKey:@"created"];
}

@dynamic name;
@dynamic complete;
@dynamic created;

- (BOOL)isComplete {
    return [[self complete] boolValue];
}

@end
