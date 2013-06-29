//
//  KFSearchableTableViewController.m
//  KFData
//
//  Created by Calvin Cestari on 09/03/2013.
//  Copyright (c) 2013 Calvin Cestari. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFSearchableTableViewController.h"

typedef NS_ENUM(NSUInteger, KFScrollDirection) {
    KFScrollDirectionNone,
    KFScrollDirectionUp,
    KFScrollDirectionDown,
};

@interface KFSearchableTableViewController ()

@property (nonatomic, strong, readwrite) UISearchBar* searchBar;
@property (nonatomic, assign, readwrite, getter=isFiltering) BOOL filtering;
@property (nonatomic, strong) NSPredicate* originalPredicate;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) KFScrollDirection scrollDirection;

@end

@implementation KFSearchableTableViewController

#pragma mark - Instance methods

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	if (!(self = [super initWithManagedObjectContext:managedObjectContext])) {
		return nil;
	}

	[self setFiltering:NO];
    [self setAutoHideActiveSearchBar:NO];

	return self;
}

- (void)loadView {
    [super loadView];

    if ([self searchBar] == nil) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 44.0f)];
        [self setSearchBar:searchBar];
    }

	[[self searchBar] setDelegate:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[[self tableView] setTableHeaderView:[self searchBar]];
    CGRect searchFrame = [[self searchBar] frame];
	[[self tableView] setContentOffset:CGPointMake(0.0f, searchFrame.size.height) animated:NO];
}

- (NSPredicate*)predicateForSearchText:(NSString*)searchText {
	NSAssert(NO, @"Subclasses must override this method to provide a search predicate");
	return nil;
}

- (void)setFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    [super setFetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath];

    [self setOriginalPredicate:[[[self fetchedResultsController] fetchRequest] predicate]];

    [[self searchBar] resignFirstResponder];
    [[self searchBar] setShowsCancelButton:NO animated:YES];
    [[self searchBar] setText:nil];
    [self setFiltering:NO];
}

- (KFScrollPosition)scrollPosition {
    CGFloat yOffset = [[self tableView] contentOffset].y;
    if (0 == yOffset) {
        return KFScrollPositionSearch;
    }

    CGFloat searchBarHeight = [[self searchBar] frame].size.height;
    if (yOffset == searchBarHeight) {
        return KFScrollPositionTopRow;
    }

    CGFloat contentHeight = [[self tableView] contentSize].height;
    CGFloat frameHeight = [[self tableView] frame].size.height;
    if (frameHeight == (contentHeight - yOffset)) {
        return KFScrollPositionBottomRow;
    }

    return KFScrollPositionOther;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
    [self setFiltering:[searchText length] ? YES : NO];

	NSPredicate *predicate;

    if ([searchText length]) {
        if ([self originalPredicate]) {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[
                            [self originalPredicate],
                            [self predicateForSearchText:searchText],
                        ]];
        } else {
            predicate = [self predicateForSearchText:searchText];
        }
    } else {
        predicate = [self originalPredicate];
    }

    [[[self fetchedResultsController] fetchRequest] setPredicate:predicate];

	[super performFetch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:nil];

    [[[self fetchedResultsController] fetchRequest] setPredicate:[self originalPredicate]];
    [super performFetch];

    [self setFiltering:NO];

    CGSize searchBarSize = [[self searchBar] frame].size;
    [[self tableView] setContentOffset:CGPointMake(0.0f, searchBarSize.height) animated:YES];
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
		[self setScrollDirection:KFScrollDirectionUp];
	} else if ([self lastContentOffset] < [scrollView contentOffset].y) {
		[self setScrollDirection:KFScrollDirectionDown];
    }

	[self setLastContentOffset:[scrollView contentOffset].y];
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self updateOffsetForSearchBarAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateOffsetForSearchBarAnimated:YES];
}

- (void)updateOffsetForSearchBarAnimated:(BOOL)animated {
    CGSize searchBarSize = [[self searchBar] frame].size;
    UITableView *tableView = [self tableView];

    switch ([self scrollDirection]) {
        case KFScrollDirectionDown: {
            if ([tableView contentOffset].y < (searchBarSize.height / 5 * 1)) {
                [tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
            } else if (([[self tableView] contentOffset].y > (searchBarSize.height / 5 * 1)) && ([tableView contentOffset].y < searchBarSize.height)) {
                if ([self isFiltering] && NO == [self canAutoHideActiveSearchBar]) {
                    [tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
                } else {
                    [tableView setContentOffset:CGPointMake(0.0f, searchBarSize.height) animated:animated];
                }
            }

            break;
        }

        case KFScrollDirectionUp: {
            if ([tableView contentOffset].y < (searchBarSize.height / 5 * 4)) {
                [tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
            } else if ([[self tableView] contentOffset].y <  searchBarSize.height) {
                if ([self isFiltering] && NO == [self canAutoHideActiveSearchBar]) {
                    [tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
                } else {
                    [tableView setContentOffset:CGPointMake(0.0f,  searchBarSize.height) animated:animated];
                }
            }

            break;
        }

        case KFScrollDirectionNone:
            break;
	}
}

@end
#endif
