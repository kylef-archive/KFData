//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFFetchedResultsTableController.h"

@class NSManagedObjectContext;
@class KFDataStore;

@interface KFDataTableViewController : UITableViewController <KFFetchedResultsTableControllerDelegate>

@property (nonatomic, strong) KFFetchedResultsTableController *fetchedResultsTableController;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithDataStore:(KFDataStore*)dataStore;
- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;


/* The completion handler will execute when the fetch request is complete on
   the main thread */
- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath
        completionBlock:(void (^)(NSFetchedResultsController *))completionHandler;

@end

