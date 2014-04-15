//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class KFObjectManager;
@class KFDataTableViewDataSource;

/** KFDataTableViewController is a generic controller base uses
 KFDataTableViewDataSource as a data source. Providing helper methods for
 ease of use.
*/

@interface KFDataTableViewController : UITableViewController

@property (nonatomic, strong) KFDataTableViewDataSource *dataSource;

/** Set the fetch request to populate the table view
 @note This must be called after the table view is loaded
 */
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                      cacheName:(NSString *)cacheName;

/** Set the an object manager to populate the table view
 @note This must be called after the table view is loaded
 */
- (void)setObjectManager:(KFObjectManager *)objectManager
      sectionNameKeyPath:(NSString *)sectionNameKeyPath
               cacheName:(NSString *)cacheName;

/** Executes the fetch request on the store to get objects and load them into the collection view.
 @returns YES if successful or NO (and an error) if a problem occurred.
 An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.'
 */
- (BOOL)performFetch:(NSError **)error;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath;

/** Overiding point for setting a custom data source class for setManagedObjectContext:fetchRequest:sectionNameKeyPath:cacheName: and setObjectManager:sectionNameKeyPath:cacheName:
 @return By default, this method returns KFDataTableViewDataSource
 */
- (Class)dataSourceClass;

@end

#endif
