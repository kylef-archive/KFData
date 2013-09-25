//
//  KFObjectManager
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import "KFObjectManager.h"


NSString * const KFDataErrorDomain = @"KFDataErrorDomain";

@interface KFObjectManager ()

@property (nonatomic, strong) NSArray *resultsCache;

@end

@implementation KFObjectManager

#pragma mark - Creation

+ (instancetype)objectManagerInContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription {
    return [[self alloc] initInContext:managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:nil];
}

+ (instancetype)objectManagerInContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [[self alloc] initInContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors];
}

- (instancetype)initInContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSParameterAssert(managedObjectContext != nil);
    NSParameterAssert(entityDescription != nil);

    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
        _entityDescription = entityDescription;
        _predicate = [predicate copy];
        _sortDescriptors = [sortDescriptors copy];
    }

    return self;
}

- (instancetype)init {
    NSString *reason = [NSString stringWithFormat:@"%@ Failed to call designated initializer.", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

#pragma mark - Equality

- (NSUInteger)hash {
    return [[self managedObjectContext] hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if ([object isKindOfClass:[KFObjectManager class]] == NO) {
        return NO;
    }

    return [self isEqualToObjectManager:object];
}

- (BOOL)isEqualToObjectManager:(KFObjectManager *)objectManager {
    return (
        [[self managedObjectContext] isEqual:[objectManager managedObjectContext]] &&
        [[self entityDescription] isEqual:[objectManager entityDescription]] &&
        [[self predicate] isEqual:[objectManager predicate]] &&
        [[self sortDescriptors] isEqual:[objectManager sortDescriptors]]
    );
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initInContext:[self managedObjectContext] entityDescription:[self entityDescription] predicate:[self predicate] sortDescriptors:[self sortDescriptors]];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    if (_resultsCache == nil) {
        [self array:nil];
    }

    return [_resultsCache countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Fetching

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[[self entityDescription] name]];
    [fetchRequest setPredicate:[self predicate]];
    [fetchRequest setSortDescriptors:[self sortDescriptors]];
    return fetchRequest;
}

- (NSUInteger)count:(NSError **)error {
    NSUInteger count = 0;

    if (_resultsCache) {
        count = [_resultsCache count];
    } else {
        NSFetchRequest *fetchRequest = [self fetchRequest];
        count = [[self managedObjectContext] countForFetchRequest:fetchRequest error:error];
    }

    return count;
}

- (NSArray *)array:(NSError **)error {
    NSArray *array;

    if (_resultsCache) {
        array = _resultsCache;
    } else {
        array = [[self managedObjectContext] executeFetchRequest:[self fetchRequest] error:error];
        _resultsCache = array;
    }

    return array;
}

- (NSSet *)set:(NSError **)error {
    NSArray *array = [self array:error];
    NSSet *set;

    if (array != nil) {
        set = [NSSet setWithArray:array];
    }

    return set;
}

- (NSOrderedSet *)orderedSet:(NSError **)error {
    NSArray *array = [self array:error];
    NSOrderedSet *orderedSet;

    if (array != nil) {
        orderedSet = [NSOrderedSet orderedSetWithArray:array];
    }

    return orderedSet;
}

- (void)enumerateObjects:(void (^)(NSManagedObject *object, NSUInteger index, BOOL *stop))block error:(NSError **)error {
    NSArray *array = [self array:error];

    if (array != nil) {
        [array enumerateObjectsUsingBlock:block];
    }
}

- (void)each:(void (^)(NSManagedObject *managedObject))block error:(NSError **)error {
    NSArray *array = [self array:error];

    if (array != nil) {
        for (NSManagedObject *managedObject in array) {
            block(managedObject);
        }
    }
}

#pragma mark - Deletion

- (NSUInteger)deleteObjects:(NSError **)error {
    NSArray *array = [self array:error];

    NSUInteger count = 0;

    if (array != nil) {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

        for (NSManagedObject *managedObject in array) {
            [managedObjectContext deleteObject:managedObject];
            ++count;
        }
    }

    return count;
}

@end

@implementation KFObjectManager (Sorting)

- (instancetype)orderBy:(NSArray *)sortDescriptors {
    return [KFObjectManager objectManagerInContext:_managedObjectContext entityDescription:_entityDescription predicate:_predicate sortDescriptors:sortDescriptors];
}

- (instancetype)reverse {
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:[_sortDescriptors count]];

    for (NSSortDescriptor *sortDescriptor in _sortDescriptors) {
        [sortDescriptors addObject:[sortDescriptor reversedSortDescriptor]];
    }

    return [KFObjectManager objectManagerInContext:_managedObjectContext entityDescription:_entityDescription predicate:_predicate sortDescriptors:sortDescriptors];
}

@end

@implementation KFObjectManager (Filtering)

- (instancetype)exclude:(NSPredicate *)predicate {
    predicate = [[NSCompoundPredicate alloc] initWithType:NSNotPredicateType subpredicates:@[predicate]];

    if (_predicate) {
        predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[_predicate, predicate]];
    }

    return [KFObjectManager objectManagerInContext:_managedObjectContext entityDescription:_entityDescription predicate:predicate sortDescriptors:_sortDescriptors];
}

- (instancetype)filter:(NSPredicate *)predicate {
    if (_predicate) {
        predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[_predicate, predicate]];
    }

    return [KFObjectManager objectManagerInContext:_managedObjectContext entityDescription:_entityDescription predicate:predicate sortDescriptors:_sortDescriptors];
}

@end

@implementation KFObjectManager (SingleObject)

- (NSManagedObject *)object:(NSError **)error {
    NSManagedObject *managedObject;
    NSArray *array;

    if (_resultsCache) {
        array = _resultsCache;
    } else {
        NSFetchRequest *fetchRequest = [self fetchRequest];
        [fetchRequest setFetchBatchSize:1]; // Only request one

        array = [[self managedObjectContext] executeFetchRequest:[self fetchRequest] error:error];
    }

    NSUInteger count = [array count];

    if (count == 1) {
        managedObject = [array objectAtIndex:0];
    } if (count > 1) {
        *error = [NSError errorWithDomain:KFDataErrorDomain code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"Find object in fetch request failed, should only result in a single result.",
        }];
    }

    return managedObject;
}

- (NSManagedObject *)firstObject:(NSError **)error {
    NSManagedObject *managedObject;

    if (_resultsCache) {
        if ([_resultsCache count] > 0) {
            managedObject = [_resultsCache objectAtIndex:0];
        }
    } else {
        NSFetchRequest *fetchRequest = [self fetchRequest];
        [fetchRequest setFetchLimit:1];

        NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:error];

        if ([array count] > 0) {
            managedObject = [array objectAtIndex:0];
        }
    }

    return managedObject;
}

- (NSManagedObject *)lastObject:(NSError **)error {
    NSManagedObject *managedObject;

    if (_resultsCache) {
        managedObject = [_resultsCache lastObject];
    } else {
        NSFetchRequest *fetchRequest = [self fetchRequest];
        NSArray *array = [[self managedObjectContext] executeFetchRequest:fetchRequest error:error];
        managedObject = [array lastObject];
    }
    
    return managedObject;
}

@end
