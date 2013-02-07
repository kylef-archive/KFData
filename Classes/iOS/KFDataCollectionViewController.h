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
#import "KFDataViewControllerProtocol.h"

/* Add #define KFDataPSTCollectionViewController to your pch file if you want
   to use this on iOS5 along with PSTCollectionView */

#ifdef KFDataPSTCollectionViewController
#import "PSTCollectionViewController.h"
#import "PSTCollectionViewFlowLayout.h"
#endif

#import "KFDataViewControllerProtocol.h"

#ifdef KFDataPSTCollectionViewController
@interface KFDataCollectionViewController : PSTCollectionViewController <KFDataListViewControllerProtocol,
                                                                         NSFetchedResultsControllerDelegate>
#else
@interface KFDataCollectionViewController : UICollectionViewController <KFDataListViewControllerProtocol
                                                                        NSFetchedResultsControllerDelegate>
#endif

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
#ifdef KFDataPSTCollectionViewController
              collectionViewLayout:(PSTCollectionViewFlowLayout*)collectionViewLayout;
#else
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;
#endif

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

- (void)performFetch;

@end

#endif
