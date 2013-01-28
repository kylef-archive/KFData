//
//  KFDataCollectionViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#ifdef KFDataPSTCollectionViewController
#import "PSTCollectionView.h"
#endif

#import "KFDataCollectionViewController.h"

@implementation KFDataCollectionViewController

#pragma mark -

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
#ifdef KFDataPSTCollectionViewController
              collectionViewLayout:(PSTCollectionViewFlowLayout*)collectionViewLayout
#else
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout
#endif
{
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        _managedObjectContext = managedObjectContext;
        
        NSManagedObjectContext *parentContext = [managedObjectContext parentContext];
        if (parentContext) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChanges:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:parentContext];
        }
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)mergeChanges:(NSNotification*)notification {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    [managedObjectContext performBlock:^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

#pragma mark -

- (void)setFetchRequest:(NSFetchRequest *)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:managedObjectContext
                                                                                                 sectionNameKeyPath:sectionNameKeyPath
                                                                                                          cacheName:nil];
    
    [self setFetchedResultsController:fetchedResultsController];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    
    [fetchedResultsController setDelegate:self];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    [managedObjectContext performBlock:^{
        NSError *fetchError;
        if ([fetchedResultsController performFetch:&fetchError] == NO) {
            NSLog(@"KFData: Fetch request error: %@", fetchError);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self collectionView] reloadData];
        });
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self collectionView] reloadData];
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (NSInteger)[[[self fetchedResultsController] sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsController] sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:(NSUInteger)section];
    
	NSUInteger count = [sectionInfo numberOfObjects];
	return (NSInteger)count;
}

@end

#endif

