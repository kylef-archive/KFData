//
//  KFDataCollectionViewController.h
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KFDataViewControllerProtocol.h"

@interface KFDataCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (id)initWithDataStore:(KFDataStore*)dataStore
   collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

@end
