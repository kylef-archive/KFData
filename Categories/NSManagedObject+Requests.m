//
//  NSManagedObject+Requests.m
//  Pods
//
//  Created by Calvin Cestari on 11/12/2012.
//
//

#import "NSManagedObject+Requests.h"
#import "NSManagedObject+KFData.h"

@implementation NSManagedObject (Requests)

+ (NSFetchRequest*)createFetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self entityDescriptionInManagedObjectContext:managedObjectContext]];
    
    return fetchRequest;
}

#pragma mark -

+ (NSFetchRequest*)requestAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    return [self createFetchRequestInManagedObjectContext:managedObjectContext];
}

+ (NSFetchRequest*)requestAllWithPredicate:(NSPredicate*)searchFilter
                    inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [self createFetchRequestInManagedObjectContext:managedObjectContext];
    [fetchRequest setPredicate:searchFilter];
    
    return fetchRequest;
}

+ (NSFetchRequest*)requestAllSortedBy:(NSString*)sortTerm
                            ascending:(BOOL)ascending
               inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:nil inManagedObjectContext:managedObjectContext];
}

+ (NSFetchRequest*)requestAllSortedBy:(NSString*)sortTerm
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)searchFilter
               inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [self createFetchRequestInManagedObjectContext:managedObjectContext];
	if (searchFilter)
	{
		[fetchRequest setPredicate:searchFilter];
	}
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys)
    {
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

@end
