//
//  KFSearchableTableViewController.h
//  KFData
//
//  Created by Calvin Cestari on 09/03/2013.
//  Copyright (c) 2013 Calvin Cestari. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataTableViewController.h"

typedef NS_ENUM(NSUInteger, KFScrollPosition) {
    KFScrollPositionSearch, // the search bar is visible; content offset = 0
    KFScrollPositionTopRow, // the first row is fully visible at the top; content offset = search bar height
    KFScrollPositionBottomRow, // the last row is fully visible at the bottom
    KFScrollPositionOther, // the first or last row is partially offscreen
};

/**
 KFSearchableTableViewController is a subclass of KFDataTableViewController which adds
 a UISearchBar to the tableview as a header.
 */

@interface KFSearchableTableViewController : KFDataTableViewController <UISearchBarDelegate>

@property (nonatomic, strong, readonly) UISearchBar* searchBar;
@property (nonatomic, assign, readonly, getter=isFiltering) BOOL filtering;

/** This property specifies whether the autohide functionality of the search bar is allowed
 when there is search text.
 */
@property (nonatomic, assign, getter=canAutoHideActiveSearchBar) BOOL autoHideActiveSearchBar;

/** @name Subclass override */

/** This method will return the predicate to be used by the NSFetchedResultsController. It is
 important to note that the predicate returned will be used to form a compound predicate in
 conjunction with the original predicate supplied to the NSFetchedResultsController. When the
 search is cancelled or searchText is empty the original predicate alone will be used.

 @param searchText The text contents of the UISearchBar.
 @return Predicate to be used for data lookup.
 */
- (NSPredicate*)predicateForSearchText:(NSString*)searchText;

/** Returns the current scroll position within the context of search bar, top row, bottom row
 and inner rows.
 
 @return A KFScrollPosition value
 */
- (KFScrollPosition)scrollPosition;

@end
#endif

