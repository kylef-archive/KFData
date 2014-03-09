//
//  NSManagedObject+KFDataManager.h
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>


@class KFObjectManager;

/**
 KFData NSManagedObject helpers
 */

@interface NSManagedObject (KFDataManager)

/**
 The entity name for the managed object.
 @return Entity name for the managed object.
 @note This is generated from the class name, you should overide the method in
  your subclass if your entity is not named after the class.
 */
+ (NSString *)entityName;

/** A manager for the current entity
 A subclass can optionally overide providing a default sort order.
 @return A managed configured for the entity.
 @note This method uses `-entityName`.
 */
+ (KFObjectManager *)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __attribute((nonnull));

/** Returns a new object in the managed object context.
 @note This method uses `-entityName` to lookup the entity.
 */
+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __attribute((nonnull));

@end
