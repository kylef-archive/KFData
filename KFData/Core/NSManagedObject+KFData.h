//
//  NSManagedObject+KFData.h
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 KFData NSManagedObject helpers
 */

@interface NSManagedObject (KFData)

/**
 The entity name for the managed object.
 @return Entity name for the managed object.
 @note This is generated from the class name, you should overide the method in
  your subclass if your entity is not named after the class.
 */
+ (NSString*)entityName;

+ (NSArray*)executeFetchRequest:(NSFetchRequest*)fetchRequest
         inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)executeFetchRequestAndEnsureSingleObject:(NSFetchRequest*)fetchRequest
									  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest*)fetchRequest
									 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (instancetype)executeFetchRequestAndReturnLastObject:(NSFetchRequest*)fetchRequest
									inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSEntityDescription*)entityDescriptionInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

/** Create an instance of the object in the managed object context
 @param managedObjectContext Context where the managed object should be created
 @return An instance of the managed object
 */
+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                withPredicate:(NSPredicate*)predicate;
+ (NSUInteger)removeAllInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                             excludingObjects:(NSSet*)excludedObjects;

@end
