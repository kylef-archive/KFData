//
//  KFDataCollectionViewController.h
//
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "KFDataCollectionViewDataSource.h"

@class KFObjectManager;

/** KFDataCollectionViewDataSourceController is a simple data source that routes the calls for collectionView:cellForItemAtIndexPath: and collectionView:viewForSupplementaryElementOfKind:atIndexPath:
 to the collection view delegate. It is an easy method of providing the cell construction methods without the need for a custom data source class.
 */

@interface KFDataCollectionViewDataSourceController : KFDataCollectionViewDataSource

@end

/** KFDataCollectionViewController is a generic controller base that uses
 KFDataCollectionViewDataSource as a data source. Providing helper methods
 for ease of use.
 */

@interface KFDataCollectionViewController : UICollectionViewController

@property (nonatomic, strong) KFDataCollectionViewDataSource *dataSource;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                      cacheName:(NSString *)cacheName;

- (void)setObjectManager:(KFObjectManager *)objectManager
      sectionNameKeyPath:(NSString *)sectionNameKeyPath
               cacheName:(NSString *)cacheName;

- (BOOL)performFetch:(NSError **)error;

/** Overiding point for setting a custom data source class for setManagedObjectContext:fetchRequest:sectionNameKeyPath:cacheName: and setObjectManager:sectionNameKeyPath:cacheName:
 @return By default, this method returns KFDataCollectionViewDataSource
 */
- (Class)dataSourceClass;

@end

#endif
