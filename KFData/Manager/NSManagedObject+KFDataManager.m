//
//  NSManagedObject+KFDataManager.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFDataManager.h"
#import "KFObjectManager.h"

@implementation NSManagedObject (KFDataManager)

#pragma mark - Entity

+ (NSString *)entityName {
    NSString *entityName = [[self class] description];
    return entityName;
}

+ (NSEntityDescription *)kf_entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSString *entityName = [self entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];

    return entityDescription;
}

+ (KFObjectManager *)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSParameterAssert(managedObjectContext != nil);
    NSEntityDescription *entityDescription = [self kf_entityDescriptionInManagedObjectContext:managedObjectContext];
    return [KFObjectManager managerWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:nil];
}

+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSParameterAssert(managedObjectContext != nil);
    NSEntityDescription *entityDescription = [self kf_entityDescriptionInManagedObjectContext:managedObjectContext];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
}

@end
