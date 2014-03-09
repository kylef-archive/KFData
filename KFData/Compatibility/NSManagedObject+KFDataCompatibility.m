//
//  NSManagedObject+KFDataCompatibility.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFDataCompatibility.h"
#import "NSManagedObject+KFDataManager.h"
#import "KFObjectManager.h"

@interface KFObjectManager (KFDataCompatibility)

- (instancetype)kf_compatibility_orderBy:(NSString *)sortDescriptorKeys ascending:(BOOL)ascending;

@end

@implementation KFObjectManager (KFDataCompatibility)

- (instancetype)kf_compatibility_orderBy:(NSString *)sortTerm ascending:(BOOL)ascending {
    NSArray *sortDescriptorKeys = [sortTerm componentsSeparatedByString:@","];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:[sortDescriptorKeys count]];
    for (NSString *key in sortDescriptorKeys) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }

    return [self orderBy:sortDescriptors];
}

@end


@implementation NSManagedObject (KFDataCompatibility)

#pragma mark - Fetching

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext fetchRequest:fetchRequest];
    return [manager array:nil];
}

+ (instancetype)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext fetchRequest:fetchRequest];
    return [manager object:nil];
}

+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext fetchRequest:fetchRequest];
    return [manager firstObject:nil];
}

+ (instancetype)executeFetchRequestAndReturnLastObject:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [KFObjectManager managerWithManagedObjectContext:managedObjectContext fetchRequest:fetchRequest];
    return [manager lastObject:nil];
}

#pragma mark - Removal

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [self managerWithManagedObjectContext:managedObjectContext];
    return [manager deleteObjects:nil];
}

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withPredicate:(NSPredicate *)predicate {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager deleteObjects:nil];
}

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext excludingObjects:(NSSet *)excludedObjects {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@", excludedObjects];
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] exclude:predicate];
    return [manager deleteObjects:nil];
}

#pragma mark - Count

+ (NSUInteger)countOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [self managerWithManagedObjectContext:managedObjectContext];
    return [manager count:nil];
}

+ (NSUInteger)countOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager count:nil];
}

+ (NSNumber *)numberOfObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return @([self countOfObjectsWithManagedObjectContext:managedObjectContext]);
}

+ (NSNumber *)numberOfObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return @([self countOfObjectsWithPredicate:predicate inManagedObjectContext:managedObjectContext]);
}

#pragma mark - Fetch requests

+ (NSFetchRequest *)createFetchRequestInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [[self managerWithManagedObjectContext:managedObjectContext] fetchRequest];
}

+ (NSFetchRequest *)requestAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [[self managerWithManagedObjectContext:managedObjectContext] fetchRequest];
}

+ (NSFetchRequest *)requestAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager fetchRequest];
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:nil inManagedObjectContext:managedObjectContext];
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending];

    if (manager) {
        manager = [manager filter:predicate];
    }

    return [manager fetchRequest];
}

#pragma mark - Finding

+ (NSArray *)findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [self managerWithManagedObjectContext:managedObjectContext];
    return [manager array:nil];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending];
    return [manager array:nil];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending];
    return [[manager filter:predicate] array:nil];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager array:nil];
}

#pragma mark - Single objects

+ (instancetype)findSingleInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [self managerWithManagedObjectContext:managedObjectContext];
    return [manager object:nil];
}

+ (instancetype)findSingleWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager object:nil];
}

+ (instancetype)findFirstSortedBy:(NSString *)sortKeys ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortKeys ascending:ascending];
    return [manager firstObject:nil];
}

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager firstObject:nil];
}

+ (instancetype)findFirstSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending] filter:predicate];
    return [manager firstObject:nil];
}

+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending];
    return [manager lastObject:nil];
}

+ (instancetype)findLastWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[self managerWithManagedObjectContext:managedObjectContext] filter:predicate];
    return [manager lastObject:nil];
}

+ (instancetype)findLastSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    KFObjectManager *manager = [[[self managerWithManagedObjectContext:managedObjectContext] kf_compatibility_orderBy:sortTerm ascending:ascending] filter:predicate];
    return [manager lastObject:nil];
}

@end
