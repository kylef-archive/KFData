//
//  KFDataTableViewDataSource.m
//  KFData
//
//  Created by Kyle Fuller on 24/09/2013.
//
//

#import "KFDataTableViewDataSource.h"
#import "KFObjectManager.h"


@interface KFDataTableViewDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation KFDataTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSParameterAssert(tableView != nil);
    NSParameterAssert(fetchedResultsController != nil);

    if (self = [super init]) {
        _tableView = tableView;
        [tableView setDataSource:self];

        _fetchedResultsController = fetchedResultsController;
        [_fetchedResultsController setDelegate:self];
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

    return [self initWithTableView:tableView managedObjectContext:[objectManager managedObjectContext] fetchRequest:[objectManager fetchRequest] sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [_fetchedResultsController managedObjectContext];
}

- (NSFetchRequest *)fetchRequest {
    return [_fetchedResultsController fetchRequest];
}

- (BOOL)performFetch:(NSError **)error {
    BOOL result = [[self fetchedResultsController] performFetch:error];
    [[self tableView] reloadData];
    return result;
}

#pragma mark -

- (id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSUInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
    return [sections objectAtIndex:section];
}

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [[[self sectionInfoForSection:[indexPath section]] objects] objectAtIndex:[indexPath row]];
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
            [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSection:section];
    NSUInteger count = [sectionInfo numberOfObjects];
    return (NSInteger)count;
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
            [[self managedObjectContext] deleteObject:managedObject];
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
