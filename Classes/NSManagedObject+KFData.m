//
//  NSManagedObject+KFData.m
//  KFData
//
//  Created by Kyle Fuller on 26/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "NSManagedObject+KFData.h"

@implementation NSManagedObject (KFData)

+ (NSManagedObject*)createInContext:(NSManagedObjectContext*)managedObjectContext {
    NSString *entityName = [[self class] description];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                         inManagedObjectContext:managedObjectContext];

    NSManagedObject *newObject = [[self alloc] initWithEntity:entityDescription
                               insertIntoManagedObjectContext:managedObjectContext];

    return newObject;

}

@end
