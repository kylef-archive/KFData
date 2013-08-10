//
//  NSManagedObject+Aggregation.h
//  Pods
//
//  Created by Calvin Cestari on 18/12/2012.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Aggregation)

+ (NSUInteger)countOfObjectsWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSUInteger)countOfObjectsWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSNumber*)numberOfObjectsWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSNumber*)numberOfObjectsWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
