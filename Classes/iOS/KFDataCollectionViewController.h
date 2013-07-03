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

#ifdef COCOAPODS_POD_AVAILABLE_PSTCollectionView

#import "PSTCollectionViewController.h"
@class PSTCollectionViewFlowLayout;

#endif

#import "KFDataViewControllerProtocol.h"

#ifdef COCOAPODS_POD_AVAILABLE_PSTCollectionView
@interface KFDataCollectionViewController : PSTCollectionViewController <KFDataListViewControllerProtocol,
                                                                         NSFetchedResultsControllerDelegate>
#else
@interface KFDataCollectionViewController : UICollectionViewController <KFDataListViewControllerProtocol,
                                                                        NSFetchedResultsControllerDelegate>
#endif

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
#ifdef COCOAPODS_POD_AVAILABLE_PSTCollectionView
              collectionViewLayout:(PSTCollectionViewFlowLayout*)collectionViewLayout;
#else
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;
#endif

- (instancetype)initWithCoder:(NSCoder *)coder
         managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

- (void)performFetch;

@end

#endif
