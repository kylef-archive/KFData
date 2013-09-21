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

+ (instancetype)objectManagerInContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription;
+ (instancetype)objectManagerInContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark - Equality

/** Returns a boolean indicating if the two object managers are equal. */
- (BOOL)isEqualToObjectManager:(KFObjectManager *)objectManager;

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
- (void)each:(void (^)(NSManagedObject *managedObject))block error:(NSError **)error;

#pragma mark - Deletion

- (NSUInteger)deleteObjects:(NSError **)error;

@end

@interface KFObjectManager (Sorting)

/** Returns a copy and the sort descriptors */
- (instancetype)orderBy:(NSArray *)sortDescriptors;

/** Returns a copy and reverses any sort descriptors */
- (instancetype)reverse;

@end

@interface KFObjectManager (Filtering)

/** Returns a copy filtered by a predicate */
- (instancetype)filter:(NSPredicate *)predicate;

/** Returns a copy excluding a predicate */
- (instancetype)exclude:(NSPredicate *)predicate;

@end

@interface KFObjectManager (SingleObject)

/** Returns a single object matching the filters, if there is more than one. An error will instead be returned. */
- (NSManagedObject *)object:(NSError **)error;

/** Returns the first object matching the filters and using the sort descriptors */
- (NSManagedObject *)firstObject:(NSError **)error;

/** Returns the last object matching the filters and using the sort descriptors */
- (NSManagedObject *)lastObject:(NSError **)error;

@end
