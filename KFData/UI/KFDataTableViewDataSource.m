//
//  KFDataTableViewDataSource.m
//  KFData
//
//  Created by Kyle Fuller on 24/09/2013.
//
//

#import <KFData/KFData.h>
#import "KFDataTableViewDataSource.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

@interface KFDataTableViewDataSource ()

@end

@implementation KFDataTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSParameterAssert(tableView != nil);
    NSParameterAssert(fetchedResultsController != nil);

    if (self = [super init]) {
        _tableView = tableView;
        tableView.dataSource = self;

        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsController.delegate = self;
    }

    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                     fetchRequest:(NSFetchRequest *)fetchRequest
               sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        cacheName:(NSString *)cacheName
{
    NSParameterAssert(managedObjectContext != nil);
    NSParameterAssert(fetchRequest != nil);

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
    return [self initWithTableView:tableView fetchedResultsController:fetchedResultsController];
}

- (instancetype)initWithTableView:(UITableView *)tableView objectManager:(KFObjectManager *)objectManager sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    NSParameterAssert(objectManager != nil);

    return [self initWithTableView:tableView managedObjectContext:objectManager.managedObjectContext fetchRequest:[objectManager fetchRequest] sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [_fetchedResultsController managedObjectContext];
}

- (NSFetchRequest *)fetchRequest {
    return [_fetchedResultsController fetchRequest];
}

- (BOOL)performFetch:(NSError **)error {
    BOOL result = [self.fetchedResultsController performFetch:error];
    [self.tableView reloadData];
    return result;
}

#pragma mark -

- (id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSUInteger)section {
    return self.fetchedResultsController.sections[section];
}

- (id <NSObject>)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self sectionInfoForSection:indexPath.section].objects[indexPath.row];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = [self.fetchedResultsController.sections count];

    return (NSInteger)count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSection:section];
    return (NSInteger)sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reason = [NSStringFromClass([self class]) stringByAppendingString:@" : You must override tableView:cellForRowAtIndexpath:"];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionInfoForSection:section] name];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            NSManagedObject *managedObject = [self objectAtIndexPath:indexPath];
            [self.managedObjectContext deleteObject:managedObject];

            NSError *error;
            if ([self.managedObjectContext save:&error] == NO) {
                NSLog(@"%@: Failed to save managed object context after deleting %@", NSStringFromClass([self class]), error);
            }

            break;
        }

        case UITableViewCellEditingStyleInsert:
            break;
        case UITableViewCellEditingStyleNone:
            break;
    }
}

// Index

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSArray *sectionIndexTitles = [[[self fetchedResultsController] sections] valueForKeyPath:@"indexTitle"];
//    return sectionIndexTitles;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;


@end

#endif
