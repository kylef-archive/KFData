//
//  NSManagedObject+Requests.h
//  Pods
//
//  Created by Calvin Cestari on 11/12/2012.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Requests)

+ (NSFetchRequest*)createFetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest*)requestAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest*)requestAllWithPredicate:(NSPredicate*)searchFilter
                    inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest*)requestAllSortedBy:(NSString*)sortTerm
                            ascending:(BOOL)ascending
               inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest*)requestAllSortedBy:(NSString*)sortTerm
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)searchFilter
               inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
