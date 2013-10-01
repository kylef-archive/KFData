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


/**
 KFDataCollectionViewController is a generic controller base that manages a
 collection view from a NSFetchRequest.

 It will automatically insert or update cells when changes have been made to
 the NSFetchRequest.

 Additionally, it will automatically re-fetch when the persistent store
 coordinator changes stores.
 */


@interface KFDataCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                        collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;

- (instancetype)initWithCoder:(NSCoder *)coder
         managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

- (void)performFetch;

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end

#endif
