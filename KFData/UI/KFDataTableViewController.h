//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KFDataViewControllerProtocol.h"

/**
 KFDataTableViewController is a generic controller base that manages a table
 view from a NSFetchRequest.

 It will automatically insert or update cells when changes have been made to
 the NSFetchRequest.
 
 Additionally, it will automatically re-fetch when the persistent store
 coordinator changes stores.
*/

@interface KFDataTableViewController : UITableViewController <KFDataListViewControllerProtocol,
                                                              NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
           managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                       style:(UITableViewStyle)style;

- (instancetype)initWithCoder:(NSCoder *)coder
         managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

/** Execute the fetch request */
- (void)performFetch;

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

/** It is important that you implement this method to return a cell for your managed object. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#endif
