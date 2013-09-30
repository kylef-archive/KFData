//
//  TDListViewController.h
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewController.h"

@interface TDListViewController : KFDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
