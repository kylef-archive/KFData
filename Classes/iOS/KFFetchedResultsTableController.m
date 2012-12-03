//
//  KFFetchedResultsTableController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "KFDataStore.h"
#import "KFFetchedResultsTableController.h"

@implementation KFFetchedResultsTableController

- (id)initWithDataStore:(KFDataStore*)dataStore
              tableView:(UITableView*)tableView
               delegate:(NSObject<KFFetchedResultsTableControllerDelegate>*)delegate
{
    NSManagedObjectContext *managedObjectContext = [dataStore managedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];

    if (self = [self initWithManagedObjectContext:managedObjectContext
                                        tableView:tableView
                                         delegate:delegate]) {
    }

    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                         tableView:(UITableView*)tableView
                          delegate:(NSObject<KFFetchedResultsTableControllerDelegate>*)delegate
{
    if (self = [self init]) {
        _managedObjectContext = managedObjectContext;
        _tableView = tableView;
        [self setDelegate:delegate];

        [tableView setDataSource:self];

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

#pragma mark -

- (NSManagedObject*)managedObjectForIndexPath:(NSIndexPath*)indexPath {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController];
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    return managedObject;
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
                [[self delegate] configuredCell:cell
                               forManagedObject:anObject
                                    atIndexPath:indexPath];
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
    NSObject<KFFetchedResultsTableControllerDelegate> *delegate = [self delegate];

    NSManagedObject *object = [self managedObjectForIndexPath:indexPath];

    NSString *reuseIdentifier = [delegate reuseIdentifierForManagedObject:object
                                                              atIndexPath:indexPath];

    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        if ([delegate respondsToSelector:@selector(cellForReuseIdentifier:)]) {
            cell = [delegate cellForReuseIdentifier:reuseIdentifier];
        }
    }

    NSAssert(cell != nil, @"KFFetchedResultsTableController empty cell");

    [delegate configuredCell:cell
            forManagedObject:object
                 atIndexPath:indexPath];

    return cell;
}

@end
