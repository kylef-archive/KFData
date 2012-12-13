//
//  KFDataTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataStore.h"
#import "KFFetchedResultsTableController.h"
#import "KFDataTableViewController.h"

@implementation KFDataTableViewController

#pragma mark -

- (id)initWithDataStore:(KFDataStore*)dataStore {
    NSManagedObjectContext *managedObjectContext = [dataStore managedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];

    if (self = [self initWithManagedObjectContext:managedObjectContext]) {

    }

    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

#pragma mark -

/*
- (void)loadView {
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setDelegate:self];
    [self setTableView:tableView];
    [self setView:tableView];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    KFFetchedResultsTableController *fetchedResultsTableController = [[KFFetchedResultsTableController alloc] initWithManagedObjectContext:managedObjectContext
                                                                                                                                 tableView:[self tableView]
                                                                                                                                  delegate:self];

    [self setFetchedResultsTableController:fetchedResultsTableController];
}

#pragma mark -

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath
{
    [[self fetchedResultsTableController] setFetchRequest:fetchRequest
                                       sectionNameKeyPath:sectionNameKeyPath];
}

#pragma mark -

- (NSString*)fetchedResultsTableController:(KFFetchedResultsTableController *)fetchedResultsTableController
           reuseIdentifierForManagedObject:(NSManagedObject *)managedObject
                               atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}

- (void)fetchedResultsTableController:(KFFetchedResultsTableController *)fetchedResultsTableController
                       configuredCell:(UITableViewCell *)cell
                     forManagedObject:(NSManagedObject *)managedObject
                          atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

@end

