//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
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

/** @name Subclass override */

/**
 The following methods have been depreacted. You can now subclass
 -tableView:cellForIndexPath: and call -objectAtIndexPath: to get the object.
 */

/** This method will return the reuse identifier to use for a type of cell.
 @param tableView A table-view object requesting the cell.
 @param managedObject The managed object for the cell.
 @param indexPath Index of the cell
 @return Reuse identifier for the cell
 */
- (NSString*)tableView:(UITableView*)tableView
reuseIdentifierForManagedObject:(NSManagedObject *)managedObject
           atIndexPath:(NSIndexPath *)indexPath __deprecated;

/** The following method is called to update a cell when a managed object has been updated.
 Implement this method to configure the cell for the managed object.

 @param tableView A table-view object requesting the cell.
 @param cell The cell registered for the reuse identifier, or returned by tableView:cellForReuseIdentifier:
 @param managedObject The managed object for the cell.
 @param indexPath Index path
 */
- (void)tableView:(UITableView*)tableView
   configuredCell:(UITableViewCell *)cell
 forManagedObject:(NSManagedObject *)managedObject
      atIndexPath:(NSIndexPath *)indexPath __deprecated;

/** Create a UITableViewCell for the reuseIdentifier.
 @param tableView A table-view object requesting the cell.
 @param reuseIdentifier The reuse identifier we are requesting a cell for
 @note This method will be called to grab a cell for the identifier,
  alternatively you can register a nib or class with the table
  view `registerNib:forReuseIdentifier:`.
 */
- (UITableViewCell*)tableView:(UITableView *)tableView
       cellForReuseIdentifier:(NSString *)reuseIdentifier __deprecated;

@end

#endif
