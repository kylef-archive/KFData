//
//  NSManagedObject+Finders.m
//  KFData
//
//  Created by Calvin Cestari on 11/12/2012.
//  Copyright (c) 2012 Calvin Cestari. All rights reserved.
//

#import "NSManagedObject+Finders.h"
#import "NSManagedObject+Requests.h"
#import "NSManagedObject+KFData.h"

@implementation NSManagedObject (Finders)

+ (NSArray*)findAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllInManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAllSortedBy:(NSString*)sortTerm
                  ascending:(BOOL)ascending
     inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAllSortedBy:(NSString*)sortTerm
                  ascending:(BOOL)ascending
              withPredicate:(NSPredicate*)searchFilter
     inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchFilter inManagedObjectContext:managedObjectContext];
    
    return [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAllWithPredicate:(NSPredicate*)searchFilter
          inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest* fetchRequest = [self requestAllWithPredicate:searchFilter inManagedObjectContext:managedObjectContext];
    
    return [self executeFetchRequest:fetchRequest inManagedObjectContext:managedObjectContext];
}

#pragma mark -

+ (NSManagedObject*)findSingleWithPredicate:(NSPredicate*)searchFilter
					 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self requestAllWithPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndEnsureSingleObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findFirstSortedBy:(NSString*)sortTerm
							ascending:(BOOL)ascending
			   inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnFirstObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findFirstWithPredicate:(NSPredicate*)searchFilter
					inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllWithPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnFirstObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findFirstSortedBy:(NSString*)sortTerm
							ascending:(BOOL)ascending
						withPredicate:(NSPredicate*)searchFilter
			   inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnFirstObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findLastSortedBy:(NSString*)sortTerm
						   ascending:(BOOL)ascending
			  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnLastObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findLastWithPredicate:(NSPredicate*)searchFilter
				   inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllWithPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnLastObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

+ (NSManagedObject*)findLastSortedBy:(NSString*)sortTerm
						   ascending:(BOOL)ascending
					   withPredicate:(NSPredicate*)searchFilter
			  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest* fetchRequest = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchFilter inManagedObjectContext:managedObjectContext];
	
	return [self executeFetchRequestAndReturnLastObject:fetchRequest inManagedObjectContext:managedObjectContext];
}

@end
