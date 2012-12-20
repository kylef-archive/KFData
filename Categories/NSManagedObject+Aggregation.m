//
//  NSManagedObject+Aggregation.m
//  Pods
//
//  Created by Calvin Cestari on 18/12/2012.
//
//

#import "NSManagedObject+Aggregation.h"
#import "NSManagedObject+Requests.h"

@implementation NSManagedObject (Aggregation)

+ (NSUInteger)executeCountForFetchRequest:(NSFetchRequest*)fetchRequest inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	NSError* error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"executeCountForFetchRequest: failed with %d; %@", [error code], [error description]);
    }
    
    return count;
}

+ (NSUInteger)countOfObjectsWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	NSFetchRequest* fetchRequest = [self requestAllInManagedObjectContext:managedObjectContext];
    return [self executeCountForFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSUInteger)countOfObjectsWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	NSFetchRequest* fetchRequest = [self requestAllWithPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	return [self executeCountForFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSNumber*)numberOfObjectsWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    return [NSNumber numberWithUnsignedInteger:[self countOfObjectsWithManagedObjectContext:managedObjectContext]];
}

+ (NSNumber*)numberOfObjectsWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    return [NSNumber numberWithUnsignedInteger:[self countOfObjectsWithPredicate:searchFilter inManagedObjectContext:managedObjectContext]];
}

@end
