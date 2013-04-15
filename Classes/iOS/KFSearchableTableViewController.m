//
//  KFSearchableTableViewController.m
//  KFData
//
//  Created by Calvin Cestari on 09/03/2013.
//  Copyright (c) 2013 Calvin Cestari. All rights reserved.
//

#import "KFSearchableTableViewController.h"

static CGFloat const kWS_SearchBarWidth = 320.0f;
static CGFloat const kWS_SearchBarHeight = 44.0f;

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy
};

@interface KFSearchableTableViewController ()

@property (nonatomic, strong, readwrite) UISearchBar* searchBar;
@property (nonatomic, assign, readwrite, getter=isFiltering) BOOL filtering;
@property (nonatomic, strong) NSPredicate* originalPredicate;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) ScrollDirection scrollDirection;

@end

@implementation KFSearchableTableViewController

#pragma mark - Instance methods

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	if (!(self = [super initWithManagedObjectContext:managedObjectContext])) {
		return nil;
	}

	[self setFiltering:NO];

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setSearchBar:[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kWS_SearchBarWidth, kWS_SearchBarHeight)]];
	[[self searchBar] setDelegate:self];

	[[self tableView] setTableHeaderView:[self searchBar]];
	[[self tableView] setContentOffset:CGPointMake(0.0f, kWS_SearchBarHeight) animated:NO];
}

- (NSPredicate*)predicateForSearchText:(NSString*)searchText {
	NSAssert(NO, @"Subclasses must override this method to provide a search predicate");
	return nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
	if (NO == [self isFiltering]) {
		[self setOriginalPredicate:[[[self fetchedResultsController] fetchRequest] predicate]];
		[self setFiltering:YES];
	}

	NSPredicate* searchFilter = nil;
	if (nil == [self originalPredicate] && [searchText length]) {
		searchFilter = [self predicateForSearchText:searchText];
	} else {
		searchFilter = [searchText length] ? [NSCompoundPredicate andPredicateWithSubpredicates:@[[self originalPredicate], [self predicateForSearchText:searchText]]] : [self originalPredicate];
	}
	if (searchFilter) {
		[[[self fetchedResultsController] fetchRequest] setPredicate:searchFilter];
	}

	[super performFetch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
	if ([searchBar isFirstResponder]) {
		[searchBar resignFirstResponder];
		[searchBar setShowsCancelButton:NO animated:YES];
		[searchBar setText:nil];

		[[[self fetchedResultsController] fetchRequest] setPredicate:[self originalPredicate]];
		[super performFetch];

		[self setFiltering:NO];
		[self setOriginalPredicate:nil];

		[[self tableView] setContentOffset:CGPointMake(0.0f, kWS_SearchBarHeight) animated:YES];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
	if ([searchBar isFirstResponder]) {
		[searchBar resignFirstResponder];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
	if ([[self searchBar] isFirstResponder]) {
		[[self searchBar] resignFirstResponder];
	}
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
	if ([self lastContentOffset] > [scrollView contentOffset].y) {
		[self setScrollDirection:ScrollDirectionUp];
	} else if ([self lastContentOffset] < [scrollView contentOffset].y) {
		[self setScrollDirection:ScrollDirectionDown];
	}
	[self setLastContentOffset:[scrollView contentOffset].y];
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
	if (ScrollDirectionDown == [self scrollDirection]) {// && NO == decelerate) { // decelerate is always YES in iOS 5.x
		if ([scrollView contentOffset].y < kWS_SearchBarHeight/5*1) {
			[[self tableView] setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
		} else if (([scrollView contentOffset].y > kWS_SearchBarHeight/5*1) && ([scrollView contentOffset].y < kWS_SearchBarHeight)) {
			[[self tableView] setContentOffset:CGPointMake(0.0f, kWS_SearchBarHeight) animated:YES];
		}
	}
	if (ScrollDirectionUp == [self scrollDirection]) {// && NO == decelerate) { // decelerate is always YES in iOS 5.x
		if ([scrollView contentOffset].y < kWS_SearchBarHeight/5*4) {
			[[self tableView] setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
		} else if ([scrollView contentOffset].y < kWS_SearchBarHeight) {
			[[self tableView] setContentOffset:CGPointMake(0.0f, kWS_SearchBarHeight) animated:YES];
		}
	}
}

@end
