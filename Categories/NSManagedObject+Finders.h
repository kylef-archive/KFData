//
//  NSManagedObject+Finders.h
//  KFData
//
//  Created by Calvin Cestari on 11/12/2012.
//  Copyright (c) 2012 Calvin Cestari. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Finders)

+ (NSArray*)findAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)findAllSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)findAllSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)findAllWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (id)findSingleWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (id)findFirstSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)findFirstWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)findFirstSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (id)findLastSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)findLastWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)findLastSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
