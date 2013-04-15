//
//  KFDataTableViewController.m
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "KFDataStore.h"
#import "KFFetchedResultsTableController.h"

@interface KFDataTableViewController ()

@end

@implementation KFDataTableViewController

#pragma mark -

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
           managedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSParameterAssert(managedObjectContext);

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                                       style:(UITableViewStyle)style
{
    NSParameterAssert(managedObjectContext);

    if (self = [super initWithStyle:style]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    if (self = [self initWithManagedObjectContext:managedObjectContext style:UITableViewStylePlain]) {
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
         managedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSParameterAssert(managedObjectContext);

    if (self = [super initWithCoder:coder]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [self initWithCoder:coder managedObjectContext:nil]) {
        // You should probablly overide this and call the managedObjectContext method.
    }

    return self;
}

- (instancetype)init {
    if (self = [self initWithManagedObjectContext:nil style:UITableViewStylePlain]) {
        // You should probablly overide this and call the managedObjectContext method.
    }

    return self;
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

    [[self tableView] reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = [self tableView];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:indexSet
                     withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:indexSet
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableView];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

#pragma mark -

- (NSString*)tableView:(UITableView*)tableView
    reuseIdentifierForManagedObject:(NSManagedObject *)managedObject
           atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}

- (void)tableView:(UITableView*)tableView
   configuredCell:(UITableViewCell *)cell
 forManagedObject:(NSManagedObject *)managedObject
      atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForReuseIdentifier:(NSString *)reuseIdentifier {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = [[self fetchedResultsController] sections];
    NSUInteger count = [sections count];

    return (NSInteger)count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];

	NSUInteger count = [sectionInfo numberOfObjects];
	return (NSInteger)count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    NSString *reuseIdentifier = [self tableView:tableView reuseIdentifierForManagedObject:managedObject
                                    atIndexPath:indexPath];

    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        cell = [self tableView:tableView cellForReuseIdentifier:reuseIdentifier];
    }

    NSParameterAssert(cell);

    [self tableView:tableView configuredCell:cell forManagedObject:managedObject atIndexPath:indexPath];

    return cell;
}

@end

#endif
