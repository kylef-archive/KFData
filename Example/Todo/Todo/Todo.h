//
//  Todo.h
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Todo : NSManagedObject

/** Returns a managed for only completed tasks */
+ (KFObjectManager *)completedManagerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (KFAttribute *)name;
+ (KFAttribute *)complete;
+ (KFAttribute *)created;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSDate * created;

- (BOOL)isComplete;

@end
