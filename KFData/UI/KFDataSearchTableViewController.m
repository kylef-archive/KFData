//
//  KFDataSearchTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 01/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <KFData/KFData.h>
#import "KFDataSearchTableViewController.h"
#import "KFDataTableViewDataSource.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

const CGFloat kKFDataSearchTableViewControllerSearchBarHeight = 44.0f;

@interface KFDataSearchTableViewController ()

@property (nonatomic, strong, readwrite) UISearchBar *searchBar;

@end

@implementation KFDataSearchTableViewController

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];

    if (self.searchBar == nil) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, kKFDataSearchTableViewControllerSearchBarHeight)];
    }

	self.searchBar.delegate = self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.tableHeaderView = self.searchBar;

#ifdef __IPHONE_7_0
    if (([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && [self automaticallyAdjustsScrollViewInsets]) == NO) {
        CGRect searchFrame = self.searchBar.frame;
        [self.tableView setContentOffset:CGPointMake(0.0f, CGRectGetHeight(searchFrame)) animated:NO];
    }
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSString *query = self.searchBar.text;

    if ([query length] == 0) {
        query = nil;
    }

    [self updateDataSourceForSearchQuery:query];
}

#pragma -

- (KFObjectManager *)objectManagerForSearchQuery:(NSString *)query {
    return nil;
}

- (void)updateDataSourceForSearchQuery:(NSString *)query {
    KFObjectManager *manager = [self objectManagerForSearchQuery:query];

    NSAssert(manager != nil, @"objectManagerForSearchQuery: must be overided in %@ to always return non-nil", NSStringFromClass([self class]));

    NSPredicate *predicate = manager.predicate;
    NSArray *sortDescriptors = manager.sortDescriptors;

    NSFetchRequest *fetchRequest = [self.dataSource fetchRequest];

    // If the fetch request has changed or we don't have a fetch request, update
    if ((fetchRequest == nil) || ([[fetchRequest predicate] isEqual:predicate] == NO) || ([[fetchRequest sortDescriptors] isEqualToArray:sortDescriptors] == NO)) {
        [super setObjectManager:manager sectionNameKeyPath:nil cacheName:nil];
    }
}

#pragma mark -

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"setManagedObjectContext:fetchRequest:sectionNameKeyPath:cacheName is unavailible, please see documentation" userInfo:nil];
}

- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"setObjectManager:sectionNameKeyPath:cacheName is unavailible, please see documentation" userInfo:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)query {
    if ([query length] == 0) {
        query = nil;
    }

    [self updateDataSourceForSearchQuery:query];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = nil;
    [self updateDataSourceForSearchQuery:nil];

    [self objectManagerForSearchQuery:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if ([searchBar isFirstResponder]) {
		[searchBar resignFirstResponder];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self.searchBar isFirstResponder]) {
		[self.searchBar resignFirstResponder];
	}
}

@end

#endif
