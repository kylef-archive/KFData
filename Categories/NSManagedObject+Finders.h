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

+ (instancetype)findSingleInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)findSingleWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (instancetype)findFirstSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)findFirstWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)findFirstSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (instancetype)findLastSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)findLastWithPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)findLastSortedBy:(NSString*)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate*)searchFilter inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
