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

@interface KFDataTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation KFDataTableViewController

#pragma mark -

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;

        NSManagedObjectContext *parentContext = [managedObjectContext parentContext];
        if (parentContext) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChanges:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:parentContext];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)mergeChanges:(NSNotification*)notification {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    [managedObjectContext performBlock:^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }];
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

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    [managedObjectContext performBlock:^{
        NSError *fetchError;
        if ([fetchedResultsController performFetch:&fetchError] == NO) {
            NSLog(@"KFData: Fetch request error: %@", fetchError);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    }];
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
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

            if (cell) {
                [self tableView:tableView configuredCell:cell forManagedObject:anObject atIndexPath:indexPath];
            }

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

    NSAssert(cell != nil, @"KFDataTableViewController nil cell");

    [self tableView:tableView configuredCell:cell forManagedObject:managedObject atIndexPath:indexPath];

    return cell;
}

@end

