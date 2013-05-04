//
//  KFSearchableTableViewController.h
//  KFData
//
//  Created by Calvin Cestari on 09/03/2013.
//  Copyright (c) 2013 Calvin Cestari. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataTableViewController.h"

/**
 KFSearchableTableViewController is a subclass of KFDataTableViewController which adds
 a UISearchBar to the tableview as a header.
 */

@interface KFSearchableTableViewController : KFDataTableViewController <UISearchBarDelegate>

@property (nonatomic, strong, readonly) UISearchBar* searchBar;
@property (nonatomic, assign, readonly, getter=isFiltering) BOOL filtering;

/** @name Subclass override */

/** This method will return the predicate to be used by the NSFetchedResultsController. It is
 important to note that the predicate returned will be used to form a compound predicate in
 conjunction with the original predicate supplied to the NSFetchedResultsController. When the
 search is cancelled or searchText is empty the original predicate alone will be used.

 @param searchText The text contents of the UISearchBar.
 @return Predicate to be used for data lookup.
 */
- (NSPredicate*)predicateForSearchText:(NSString*)searchText;

@end
#endif

