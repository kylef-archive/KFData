//
//  NSManagedObject+KFData.h
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (KFData)

+ (NSManagedObject*)createInContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest*)fetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                withPredicate:(NSPredicate*)predicate;

// Returns a single object matching a predicate
+ (NSManagedObject*)objectForPredicate:(NSPredicate*)predicate
                inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
