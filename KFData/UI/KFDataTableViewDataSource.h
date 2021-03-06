//
//  KFDataTableViewDataSource.h
//  KFData
//
//  Created by Kyle Fuller on 24/09/2013.
//
//

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class KFDataTableViewDataSource;
@class KFObjectManager;


/** KFDataTableViewDataSource is a table view data source for dealing with a
 fetch request. It handles updating the table view and also handles deletion
 of a row from `tableView:commitEditingStyle:forRowAtIndexPath:`. To use this
 class, you will need subclass and overide UITableViewDataSource methods you
 want to implement. Such as `tableView:cellForRowAtIndexPath:`.
 */

@interface KFDataTableViewDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

/// The table view the data source was initialized with
@property (nonatomic, strong, readonly) UITableView *tableView;
/// The managed object context the data source was initialized with
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
/// The fetch request the data source was initialized with
@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;
/// A fetched results controller created to managed the query
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) UITableViewCell *(^cellForManagedObject)(UITableView *tableView, NSIndexPath *indexPath, NSManagedObject *managedObject);

- (instancetype)initWithTableView:(UITableView *)tableView
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                     fetchRequest:(NSFetchRequest *)fetchRequest
               sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        cacheName:(NSString *)cacheName;

- (instancetype)initWithTableView:(UITableView *)tableView
                    objectManager:(KFObjectManager *)objectManager
               sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        cacheName:(NSString *)cacheName;

- (instancetype)initWithTableView:(UITableView *)tableView
                    objectManager:(KFObjectManager *)objectManager;

/** Executes the fetch request on the store to get objects and load them into the table view.
 @returns YES if successful or NO (and an error) if a problem occurred.
 An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.'
 */
- (BOOL)performFetch:(NSError **)error;

/** Retrieve the object for the index path
 @param indexPath to retrieve the object for
 @return The managed object for this index path.
 */
- (id <NSObject>)objectAtIndexPath:(NSIndexPath *)indexPath;

/** Retreive the section info for a section
 @param section to retrieve the section info for
 @return The section info for the given section
 */
- (id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSUInteger)section;

@end

/** An alternative table view data source which provides custom sorting though
    a comparitor block. This will fetch the whole set of results into memory
    and sort them. */

@interface KFDataTableViewSortedDataSource : KFDataTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                     fetchRequest:(NSFetchRequest *)fetchRequest
                       comparator:(NSComparator)comparator;

- (instancetype)initWithTableView:(UITableView *)tableView
                    objectManager:(KFObjectManager *)objectManager
                       comparator:(NSComparator)comparator;

@end

#endif
