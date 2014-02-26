//
//  KFDataCollectionViewController.m
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import "KFDataCollectionViewController.h"
#import "KFDataCollectionViewDataSource.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

@interface KFDataCollectionViewDataSourceController : KFDataCollectionViewDataSource

@end

@implementation KFDataCollectionViewDataSourceController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [(KFDataCollectionViewController *)[collectionView delegate] collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [(KFDataCollectionViewController *)[collectionView delegate] collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

@end

@interface KFDataCollectionViewController ()

@end

@implementation KFDataCollectionViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSError *error;
    if (self.dataSource && ([self performFetch:&error] == NO)) {
        NSLog(@"KFDataCollectionViewController: Error performing fetch %@", error);
    }
}

#pragma mark -

- (void)setDataSource:(KFDataCollectionViewDataSource *)dataSource {
    if (dataSource) {
        NSParameterAssert(dataSource.collectionView == self.collectionView);
    }

    _dataSource = dataSource;

    if ([self isViewLoaded]) {
        NSError *error;
        if ([self performFetch:&error] == NO) {
            NSLog(@"KFDataCollectionViewController: Error performing fetch %@", error);
        }
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    self.dataSource = [[KFDataCollectionViewDataSourceController alloc] initWithCollectionView:[self collectionView] managedObjectContext:managedObjectContext fetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
}

- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    self.dataSource = [[KFDataCollectionViewDataSourceController alloc] initWithCollectionView:[self collectionView] objectManager:objectManager sectionNameKeyPath:sectionNameKeyPath cacheName:cacheNam]];
}

- (BOOL)performFetch:(NSError **)error {
    return [_dataSource performFetch:error];
}

@end

#endif
