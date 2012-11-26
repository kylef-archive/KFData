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

@end
