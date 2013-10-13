//
//  KFDataTableViewDataSource.h
//  KFData
//
//  Created by Kyle Fuller on 24/09/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class KFDataTableViewDataSource;
@class KFObjectManager;


/** KFDataTableViewDataSource is a table view data source for dealing with a fetch request.
 It handles updating the table view and also handles deletion of a row from `tableView:commitEditingStyle:forRowAtIndexPath:`.
 */

@interface KFDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;

- (instancetype)initWithTableView:(UITableView *)tableView
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                     fetchRequest:(NSFetchRequest *)fetchRequest
               sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        cacheName:(NSString *)cacheName;

- (instancetype)initWithTableView:(UITableView *)tableView
                    objectManager:(KFObjectManager *)objectManager
               sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        cacheName:(NSString *)cacheName;

/** Executes the fetch request on the store to get objects and load them into the table view.
 @returns YES if successful or NO (and an error) if a problem occurred.
 An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.'
 */
- (BOOL)performFetch:(NSError **)error;

/** Retrieve the object for the index path
 @param indexPath to retrieve the object for
 @return The managed object for this index path.
 */
- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
