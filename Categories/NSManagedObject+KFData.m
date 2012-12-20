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

+ (NSArray*)executeFetchRequest:(NSFetchRequest*)fetchRequest
         inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSError* error = nil;
	NSArray* results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (error) {
		NSLog(@"executeFetchRequest failed with %d; %@", [error code], [error description]);
	}
    
    return results;
}

+ (NSManagedObject*)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest*)fetchRequest
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

+ (NSManagedObject*)executeFetchRequestAndReturnFirstObject:(NSFetchRequest*)fetchRequest
									 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	[fetchRequest setFetchLimit:1];
	
	return [self executeFetchRequestAndEnsureSingleObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)executeFetchRequestAndReturnLastObject:(NSFetchRequest*)fetchRequest
									inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSArray* results = [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
	
	return [results lastObject];
}

#pragma mark - 

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

#pragma mark -

+ (NSManagedObject*)createInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:managedObjectContext];

    NSManagedObject *newObject = [[self alloc] initWithEntity:entityDescription
                               insertIntoManagedObjectContext:managedObjectContext];

    return newObject;
}

#pragma mark -

+ (NSUInteger)deleteAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    return [self deleteAllInManagedObjectContext:managedObjectContext withPredicate:nil];
}

+ (NSUInteger)deleteAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
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

@end
