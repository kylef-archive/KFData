//
//  NSManagedObject+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFData.h"
#import "KFObjectManager.h"

@implementation NSManagedObject (KFData)

#pragma mark - Entity

+ (NSString *)entityName {
    NSString *entityName = [[self class] description];
    return entityName;
}

+ (NSEntityDescription *)entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSString *entityName = [self entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];

    return entityDescription;
}

+ (KFObjectManager *)managerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];
    return [KFObjectManager objectManagerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:nil];
}

+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
}

@end
