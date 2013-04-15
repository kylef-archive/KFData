//
//  KFDataCollectionViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#ifdef __POD_PSTCollectionView
#import "PSTCollectionView.h"
#endif

#import "KFDataCollectionViewController.h"

@interface KFDataCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *sectionUpdates;
@property (nonatomic, strong) NSMutableArray *itemUpdates;

@end

@implementation KFDataCollectionViewController

#pragma mark -

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
#ifdef __POD_PSTCollectionView
              collectionViewLayout:(PSTCollectionViewFlowLayout*)collectionViewLayout
#else
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout
#endif
{
    NSParameterAssert(managedObjectContext);

    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        _managedObjectContext = managedObjectContext;
    }
    
    return self;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    if (self = [self initWithManagedObjectContext:managedObjectContext collectionViewLayout:nil]) {
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
         managedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSParameterAssert(managedObjectContext);

    if (self = [super initWithCoder:coder]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [self initWithCoder:coder managedObjectContext:nil]) {
        // You should probablly overide this and call the managedObjectContext method.
    }

    return self;
}

- (instancetype)init {
    if (self = [self initWithManagedObjectContext:nil collectionViewLayout:nil]) {
    }

    return self;
}

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self performFetch];
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
    
    if ([self isViewLoaded]) {
        [self performFetch];
    }
}

- (void)performFetch {
    NSError *fetchError;
    if ([[self fetchedResultsController] performFetch:&fetchError] == NO) {
        NSLog(@"KFData: Fetch request error: %@", fetchError);
    }

    [[self collectionView] reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self setSectionUpdates:[NSMutableArray array]];
    [self setItemUpdates:[NSMutableArray array]];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        case NSFetchedResultsChangeDelete: {
            NSDictionary *userInfo = @{@(type): [NSIndexSet indexSetWithIndex:sectionIndex]};
            [[self sectionUpdates] addObject:userInfo];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSDictionary *userInfo;

    switch (type) {
        case NSFetchedResultsChangeInsert:
            userInfo = @{@(type): @[newIndexPath]};
            break;

        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeUpdate:
            userInfo = @{@(type): @[indexPath]};
            break;

        case NSFetchedResultsChangeMove:
            userInfo = @{@(type): @[indexPath, newIndexPath]};
            break;
    }

    if (userInfo) {
        [[self itemUpdates] addObject:userInfo];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSArray *sectionUpdates = [self sectionUpdates];
    NSArray *itemUpdates = [self itemUpdates];

    [self setSectionUpdates:nil];
    [self setItemUpdates:nil];

    UICollectionView *collectionView = [self collectionView];

    if ([sectionUpdates count]) {
        [collectionView performBatchUpdates:^{
            for (NSDictionary *userInfo in [self sectionUpdates]) {
                [userInfo enumerateKeysAndObjectsUsingBlock:^(id key, NSIndexSet *indexSet, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];

                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [collectionView insertSections:indexSet];
                            break;

                        case NSFetchedResultsChangeDelete: {
                            [collectionView deleteSections:indexSet];
                            break;
                        }
                    }
                }];
            }
        } completion:nil];
    }

    if ([itemUpdates count]) {
        [collectionView performBatchUpdates:^{
            for (NSDictionary *userInfo in [self itemUpdates]) {
                [userInfo enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *indexPaths, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];

                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [collectionView insertItemsAtIndexPaths:indexPaths];
                            break;

                        case NSFetchedResultsChangeDelete:
                            [collectionView deleteItemsAtIndexPaths:indexPaths];
                            break;

                        case NSFetchedResultsChangeUpdate:
                            [collectionView reloadItemsAtIndexPaths:indexPaths];
                            break;

                        case NSFetchedResultsChangeMove: {
                            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
                            NSIndexPath *newIndexPath = [indexPaths objectAtIndex:0];
                            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                            break;
                        }
                    }
                }];
            }
        } completion:nil];
    }
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

