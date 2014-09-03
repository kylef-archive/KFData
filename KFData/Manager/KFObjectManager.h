//
//  KFFetchRequest.h
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QueryKit/QueryKit.h>


/**
 Represents a lazy Core Data lookup for a set of objects.

 This object is immutable, any changes will normally be done to a copy. Such
 as with the `-filter:`, `-exclude:`, `-orderBy:` and `-reverse` methods.
 */

@interface KFObjectManager : QKQuerySet

#pragma mark - Creation

+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription __attribute((nonnull));
+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors __attribute((nonnull(1, 2)));
+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest __attribute((nonnull));

#pragma mark - Equality

/** Returns a Boolean value that indicates whether a given object manager is equal to the receiver
 @param objectManager The object manager to compare against the receiver
 @return YES if object manager is equivalent to the receiver
 */
- (BOOL)isEqualToManager:(KFObjectManager *)objectManager;

@end
