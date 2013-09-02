//
//  KFFetchRequest.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 Represents a lazy Core Data lookup for a set of objects.
 
 This object is immutable, any changes will normally be done to a copy. Such
 as with the `-filter:`, `-exclude`, `-orderBy:` and `-reverse` methods.
 */

@interface KFObjectManager : NSObject <NSFastEnumeration, NSCopying>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSEntityDescription *entityDescription;

@property (nonatomic, copy, readonly) NSPredicate *predicate;
@property (nonatomic, copy, readonly) NSArray *sortDescriptors;

#pragma mark - Creation

+ (instancetype)objectManagerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription;
+ (instancetype)objectManagerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark - Equality

/** Returns a boolean indicating if the two object managers are equal. */
- (BOOL)isEqualToObjectManager:(KFObjectManager *)objectManager;

#pragma mark - Filtering

/** Returns a copy filtered by a predicate */
- (instancetype)filter:(NSPredicate *)predicate;

/** Returns a copy excluding a predicate */
- (instancetype)exclude:(NSPredicate *)predicate;

#pragma mark - Sorting

/** Returns a copy and the sort descriptors */
- (instancetype)orderBy:(NSArray *)sortDescriptors;

/** Returns a copy and reverses any sort descriptors */
- (instancetype)reverse;

#pragma mark -

/** Returns a fetch request for the manager */
- (NSFetchRequest *)fetchRequest;

/** Counts the amount of objects for the manager */
- (NSUInteger)count:(NSError **)error;
- (NSArray *)array:(NSError **)error;
- (NSSet *)set:(NSError **)error;
- (NSOrderedSet *)orderedSet:(NSError **)error;

#pragma mark - Enumeration

- (void)enumerateObjects:(void (^)(NSManagedObject *object, NSUInteger index, BOOL *stop))block error:(NSError **)error;

#pragma mark - Single objects

- (NSManagedObject *)object:(NSError **)error;
- (NSManagedObject *)firstObject:(NSError **)error;
- (NSManagedObject *)lastObject:(NSError **)error;

#pragma mark - Deletion

- (NSUInteger)deleteObjects:(NSError **)error;

@end
