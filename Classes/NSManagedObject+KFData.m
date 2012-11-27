//
//  NSManagedObject+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFData.h"

@implementation NSManagedObject (KFData)

+ (NSString*)entityName {
    NSString *entityName = [[self class] description];
    return entityName;
}

+ (NSEntityDescription*)entityDescriptionInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSString *entityName = [self entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                         inManagedObjectContext:managedObjectContext];

    return entityDescription;
}

+ (NSManagedObject*)createInContext:(NSManagedObjectContext*)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];

    NSManagedObject *newObject = [[self alloc] initWithEntity:entityDescription
                               insertIntoManagedObjectContext:managedObjectContext];

    return newObject;
}

+ (NSFetchRequest*)fetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];

    return fetchRequest;
}

@end
