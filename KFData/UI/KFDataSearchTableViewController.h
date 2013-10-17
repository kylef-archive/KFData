//
//  KFDataSearchTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 01/10/2013.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import "KFDataTableViewController.h"


/**
 KFDataSearchTableViewController is a subclass of KFDataTableViewController which adds
 a UISearchBar to the table view as a header.
 */

@class NSFetchRequest;
@class KFObjectManager;

@interface KFDataSearchTableViewController : KFDataTableViewController <UISearchBarDelegate>

@property (nonatomic, strong, readonly) UISearchBar *searchBar;

#pragma mark -

/** This method should return an object manager for the specified query.
 @param query The query the user entered in the search bar.
 @return Returns an object manager for this query, it must not be nil
 @note The query will be nil when there is no search query. You must implement this in a subclass.
 */
- (KFObjectManager *)objectManagerForSearchQuery:(NSString *)query;

#pragma mark -

/** This method is unavailible and you should use `objectManagerForSearchQuery:` instead
 @see objectManagerForSearchQuery:
 */
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName __attribute__((unavailable));

/** This method is unavailible and you should use `objectManagerForSearchQuery:` instead
 @see objectManagerForSearchQuery:
 */
- (void)setObjectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName __attribute__((unavailable));

@end

#endif
