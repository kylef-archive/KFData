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

@class KFDataCollectionViewDataSource;
@class KFObjectManager;


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
