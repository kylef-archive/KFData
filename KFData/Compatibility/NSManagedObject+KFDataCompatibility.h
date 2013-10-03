//
//  NSManagedObject+KFDataCompatibility.h
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObject (KFDataCompatibility)

#pragma mark - Fetching

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)executeFetchRequestAndReturnLastObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Removal

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withPredicate:(NSPredicate *)predicate __deprecated;
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext excludingObjects:(NSSet *)excludedObjects __deprecated;

#pragma mark - Count

+ (NSUInteger)countOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSUInteger)countOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

+ (NSNumber *)numberOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSNumber *)numberOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Fetch requests

+ (NSFetchRequest *)createFetchRequestInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

+ (NSFetchRequest *)requestAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSFetchRequest *)requestAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Finding

+ (NSArray *)findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

+ (instancetype)findSingleInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)findSingleWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

+ (instancetype)findFirstSortedBy:(NSString *)sortKeys ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)findFirstSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)findLastWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

@end
