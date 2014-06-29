//
//  NSManagedObject+KFDataCompatibility.h
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>


/// This extension provides compatibility with KFData pre 1.0
@interface NSManagedObject (KFDataCompatibility)

#pragma mark - Fetching

/// This has been replaced by KFObjectManager
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)executeFetchRequestAndReturnLastObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Removal

/// This has been replaced by KFObjectManager
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withPredicate:(NSPredicate *)predicate __deprecated;
/// This has been replaced by KFObjectManager
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext excludingObjects:(NSSet *)excludedObjects __deprecated;

#pragma mark - Count

/// This has been replaced by KFObjectManager
+ (NSUInteger)countOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSUInteger)countOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

/// This has been replaced by KFObjectManager
+ (NSNumber *)numberOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSNumber *)numberOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Fetch requests

/// This has been replaced by KFObjectManager
+ (NSFetchRequest *)createFetchRequestInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

/// This has been replaced by KFObjectManager
+ (NSFetchRequest *)requestAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSFetchRequest *)requestAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

#pragma mark - Finding

/// This has been replaced by KFObjectManager
+ (NSArray *)findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

/// This has been replaced by KFObjectManager
+ (instancetype)findSingleInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)findSingleWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

/// This has been replaced by KFObjectManager
+ (instancetype)findFirstSortedBy:(NSString *)sortKeys ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)findFirstSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

/// This has been replaced by KFObjectManager
+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)findLastWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;
/// This has been replaced by KFObjectManager
+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __deprecated;

@end
