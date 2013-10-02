//
//  KFDataCollectionViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#import "KFDataStore.h"
#import "KFDataCollectionViewController.h"

@interface KFDataCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *sectionUpdates;
@property (nonatomic, strong) NSMutableArray *itemUpdates;

@end

@implementation KFDataCollectionViewController

#pragma mark -

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
              collectionViewLayout:(UICollectionViewLayout*)collectionViewLayout
{
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self commonInitWithManagedObjectContext:managedObjectContext];
    }
    
    return self;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [self initWithManagedObjectContext:managedObjectContext collectionViewLayout:nil]) {
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super initWithCoder:coder]) {
        [self commonInitWithManagedObjectContext:managedObjectContext];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *reason = [NSString stringWithFormat:@"%@ Failed to call designated initializer. Overide `initWithCoder:` and call `initWithCoder:managedObjectContext:` instead.", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (instancetype)init {
    NSString *reason = [NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke `initWithManagedObjectContext:` instead.", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)commonInitWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSParameterAssert(managedObjectContext != nil);

    _managedObjectContext = managedObjectContext;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidReset:) name:KFDataManagedObjectContextDidReset object:managedObjectContext];
}

- (void)dealloc {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [_managedObjectContext persistentStoreCoordinator];

    if (persistentStoreCoordinator != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:persistentStoreCoordinator];
    }
}

#pragma mark - Notification Handlers

- (void)managedObjectContextDidReset:(NSNotification *)notification {
    if ([self isViewLoaded]) {
        [self performFetch];
    }
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

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self fetchedResultsController] objectAtIndexPath:indexPath];
}

@end

#endif

