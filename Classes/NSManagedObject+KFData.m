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

#pragma mark -

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSFetchRequest *fetchRequest = [self fetchRequestInManagedObjectContext:managedObjectContext];

    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    NSUInteger removedCount = 0;

    if (error == nil) {
        removedCount = [objects count];

        for (NSManagedObject *managedObject in objects) {
            [managedObjectContext deleteObject:managedObject];
        }
    }

    return removedCount;
}

+ (NSManagedObject*)objectForPredicate:(NSPredicate*)predicate
                inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest *fetchRequest = [self fetchRequestInManagedObjectContext:managedObjectContext];
    [fetchRequest setPredicate:predicate];

    NSError *error;
    NSArray *entries = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        NSLog(@"KFData - [NSManagedObject objectForPredicate:inManagedObjectContext:] (%@)", error);
    }

    return [entries lastObject];
}

@end
