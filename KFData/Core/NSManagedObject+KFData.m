//
//  NSManagedObject+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFData.h"
#import "KFObjectManager.h"

@implementation NSManagedObject (KFData)

#pragma mark - Entity

+ (NSString*)entityName {
    NSString *entityName = [[self class] description];
    return entityName;
}

+ (NSEntityDescription*)entityDescriptionInContext:(NSManagedObjectContext*)managedObjectContext {
    NSString *entityName = [self entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];

    return entityDescription;
}

+ (KFObjectManager *)managerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInContext:managedObjectContext];
    return [KFObjectManager objectManagerInContext:managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:nil];
}

+ (instancetype)createInContext:(NSManagedObjectContext*)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInContext:managedObjectContext];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
}

@end
