//
//  KFSearchableTableViewController.h
//  KFData
//
//  Created by Calvin Cestari on 09/03/2013.
//  Copyright (c) 2013 Calvin Cestari. All rights reserved.
//

#import "KFDataTableViewController.h"

@interface KFSearchableTableViewController : KFDataTableViewController <UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) UISearchBar* searchBar;
@property (nonatomic, assign, readonly, getter=isFiltering) BOOL filtering;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
