//
//  KFDataCollectionViewDataSource.h
//  KFData
//
//  Created by Kyle Fuller on 01/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class KFObjectManager;

/** KFDataCollectionViewDataSource is a collection view data source for dealing
 with a fetch request. It handles updating the collection view when new managed
 objects match the fetch request. To use this class, you will need subclass and
 overide UICollectionViewDataSource methods you want to implement.
 Such as `collectionView:cellForItemAtIndexPath:` */

@interface KFDataCollectionViewDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                  managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                          fetchRequest:(NSFetchRequest *)fetchRequest
                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                             cacheName:(NSString *)cacheName;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                         objectManager:(KFObjectManager *)objectManager
                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                             cacheName:(NSString *)cacheName;

/** Executes the fetch request on the store to get objects and load them into the collection view.
 @returns YES if successful or NO (and an error) if a problem occurred.
 An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.'
 */
- (BOOL)performFetch:(NSError **)error;

/** Retrieve the object for the index path
 @param indexPath to retrieve the object for
 @return The managed object for this index path.
 */
- (id <NSObject>)objectAtIndexPath:(NSIndexPath *)indexPath;

- (id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSUInteger)section;

@end

#endif
