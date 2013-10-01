//
//  TDTodoViewController.h
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

@class Todo;

@interface TDTodoViewController : UIViewController

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
