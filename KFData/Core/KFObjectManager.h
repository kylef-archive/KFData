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

/** Returns a Boolean value that indicates whether a given object manager is equal to the receiver
 @param objectManager The object manager to compare against the receiver
 @return YES if object manager is equivalent to the receiver
 */
- (BOOL)isEqualToObjectManager:(KFObjectManager *)objectManager;

#pragma mark -

/** Returns a fetch request for the manager */
- (NSFetchRequest *)fetchRequest;

/** Returns the amount of objects matching the set predicate
 @param error If there is a problem fetching the count, upon return contains an instance of NSError that describes the problem.
 @return The number of objects matching the set predicate
 */
- (NSUInteger)count:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as an array
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return An array containing all matched objects
 */
- (NSArray *)array:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as an ordered set
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return An ordered set containing all matched objects
 */
- (NSSet *)set:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as a set
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return A set containing all matched objects
 */
- (NSOrderedSet *)orderedSet:(NSError **)error;

#pragma mark - Enumeration

- (void)enumerateObjects:(void (^)(NSManagedObject *object, NSUInteger index, BOOL *stop))block error:(NSError **)error;

- (void)each:(void (^)(NSManagedObject *managedObject))block error:(NSError **)error;

#pragma mark - Deletion

/** Delete all objects matching the set predicate
 @param error If there is a problem deleting the objects, upon return contains an instance of NSError that describes the problem.
 @return Returns the amount of objects that were deleted
 */
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

/** Returns a single object matching the filters, if there is more than one. An error will instead be returned.
@param error If there is a problem fetching the object or there is more than one object, upon return contains an instance of NSError that describes the problem.
@return Returns the object matching the set predicate, or nil.
 */
- (NSManagedObject *)object:(NSError **)error;

/** Returns the first object matching the filters ordered by the set sort descriptors.
 @param error If there is a problem fetching the object, upon return contains an instance of NSError that describes the problem.
 @return Returns the first object matching the set predicate, or nil.
 */
- (NSManagedObject *)firstObject:(NSError **)error;

/** Returns the last object matching the filters ordered by the set sort descriptors.
 @param error If there is a problem fetching the object, upon return contains an instance of NSError that describes the problem.
 @return Returns the last object matching the set predicate, or nil.
 */
- (NSManagedObject *)lastObject:(NSError **)error;

@end
