//
//  KFDataCollectionViewController.h
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class KFDataCollectionViewDataSource;
@class KFObjectManager;


/**
 KFDataCollectionViewController is a generic controller base that you can use
 in conjunction with KFDataCollectionViewDataSource.
 */

@interface KFDataCollectionViewController : UICollectionViewController

@property (nonatomic, strong, readonly) KFDataCollectionViewDataSource *dataSource;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                      cacheName:(NSString *)cacheName;

- (void)setObjectManager:(KFObjectManager *)objectManager
      sectionNameKeyPath:(NSString *)sectionNameKeyPath
               cacheName:(NSString *)cacheName;

- (BOOL)performFetch:(NSError **)error;

@end

#endif
