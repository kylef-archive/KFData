//
//  NSManagedObject+KFData.h
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (KFData)

+ (NSArray*)executeFetchRequest:(NSFetchRequest*)fetchRequest
         inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSManagedObject*)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest*)fetchRequest
									  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSManagedObject*)executeFetchRequestAndReturnFirstObject:(NSFetchRequest*)fetchRequest
									 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSManagedObject*)executeFetchRequestAndReturnLastObject:(NSFetchRequest*)fetchRequest
									inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSEntityDescription*)entityDescriptionInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSManagedObject*)createInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSUInteger)deleteAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSUInteger)deleteAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                withPredicate:(NSPredicate*)predicate;

@end
