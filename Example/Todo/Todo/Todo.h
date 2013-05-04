//
//  Todo.h
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Todo : NSManagedObject

+ (KFAttribute *)created;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSDate * created;

@end
