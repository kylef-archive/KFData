//
//  NNSManagedObjectContext+KFDataCompatibility.m
//  KFData
//
//  Created by Kyle Fuller on 02/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (KFDataCompatibility)

/** Deprecated because it silently handles failure
 @see performWriteBlock:success:failure: */
- (void)performWriteBlock:(void (^)(NSManagedObjectContext* managedObjectContext))writeBlock __deprecated;

@end
