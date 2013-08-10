//
//  NSManagedObject+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFData.h"
#import "NSManagedObject+Requests.h"

@implementation NSManagedObject (KFData)

#pragma mark - Entity

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

#pragma mark - Fetch request

+ (NSArray*)executeFetchRequest:(NSFetchRequest*)fetchRequest
         inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSError* error = nil;
	NSArray* results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (error) {
		NSLog(@"executeFetchRequest failed with %ld %@", (long)[error code], [error description]);
	}
    
    return results;
}

+ (instancetype)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest*)fetchRequest
									  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSArray* results = [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
	NSAssert([results count] <= 1, @"We should only have one result");
	
	if (0 == [results count])
	{
		return nil;
	}
	return [results objectAtIndex:0];
}

+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest*)fetchRequest
									 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	[fetchRequest setFetchLimit:1];
	
	return [self executeFetchRequestAndEnsureSingleObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (instancetype)executeFetchRequestAndReturnLastObject:(NSFetchRequest*)fetchRequest
									inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSArray* results = [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
	
	return [results lastObject];
}

#pragma mark - Creation

+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];

    NSManagedObject *newObject = [[self alloc] initWithEntity:entityDescription
                               insertIntoManagedObjectContext:managedObjectContext];

    return newObject;
}

#pragma mark - Removal

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    return [self removeAllInManagedObjectContext:managedObjectContext withPredicate:nil];
}

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                withPredicate:(NSPredicate*)predicate
{
    NSFetchRequest *fetchRequest = [self requestAllInManagedObjectContext:managedObjectContext];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
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

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                             excludingObjects:(NSSet*)excludedObjects
{
    NSFetchRequest *fetchRequest = [self requestAllInManagedObjectContext:managedObjectContext];

    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    NSUInteger removedCount = 0;

    if (error == nil) {
        for (NSManagedObject *managedObject in objects) {
            if ([excludedObjects containsObject:managedObject] == NO) {
                [managedObjectContext deleteObject:managedObject];
                removedCount++;
            }
        }
    }

    return removedCount;
}


@end
