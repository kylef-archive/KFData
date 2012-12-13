//
//  KFFetchedResultsTableController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KFDataStore;
@class KFFetchedResultsTableController;

@protocol KFFetchedResultsTableControllerDelegate <NSObject>

- (NSString*)fetchedResultsTableController:(KFFetchedResultsTableController*)fetchedResultsTableController
           reuseIdentifierForManagedObject:(NSManagedObject*)managedObject
                               atIndexPath:(NSIndexPath*)indexPath;

- (void)fetchedResultsTableController:(KFFetchedResultsTableController*)fetchedResultsTableController
                       configuredCell:(UITableViewCell*)cell
                     forManagedObject:(NSManagedObject*)managedObject
                          atIndexPath:(NSIndexPath*)indexPath;

@optional
- (UITableViewCell*)fetchedResultsTableController:(KFFetchedResultsTableController*)fetchedResultsTableController
                           cellForReuseIdentifier:(NSString*)reuseIdentifier;

@end

@interface KFFetchedResultsTableController : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) NSObject<KFFetchedResultsTableControllerDelegate> *delegate;

- (id)initWithDataStore:(KFDataStore*)dataStore
              tableView:(UITableView*)tableView
               delegate:(NSObject<KFFetchedResultsTableControllerDelegate>*)delegate;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                         tableView:(UITableView*)tableView
                          delegate:(NSObject<KFFetchedResultsTableControllerDelegate>*)delegate;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath
        completionBlock:(dispatch_block_t)completionHandler;

- (NSManagedObject*)managedObjectForIndexPath:(NSIndexPath*)indexPath;

@end
