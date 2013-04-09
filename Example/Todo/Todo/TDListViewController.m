//
//  TDListViewController.m
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "TDListViewController.h"
#import "TDTodoViewController.h"
#import "Todo.h"

@interface TDListViewController ()

@end

@implementation TDListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Todo"];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addTodo)];
    [[self navigationItem] setRightBarButtonItem:addButton];

    NSFetchRequest *fetchRequest = [Todo requestAllInManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setSortDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES],
    ]];
    [self setFetchRequest:fetchRequest sectionNameKeyPath:nil];
}

- (void)addTodo {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    UIViewController *addViewController = [[TDTodoViewController alloc] initWithManagedObjectContext:managedObjectContext];
    addViewController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:addViewController animated:YES completion:nil];
}

#pragma mark -

- (NSString*)tableView:(UITableView*)tableView
reuseIdentifierForManagedObject:(NSManagedObject *)managedObject
           atIndexPath:(NSIndexPath *)indexPath
{
    return @"Cell";
}

- (void)tableView:(UITableView*)tableView
   configuredCell:(UITableViewCell *)cell
 forManagedObject:(Todo *)todo
      atIndexPath:(NSIndexPath *)indexPath
{
    [[cell textLabel] setText:[todo name]];

    if ([[todo complete] boolValue]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForReuseIdentifier:(NSString *)reuseIdentifier {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

#pragma mark - Delete

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Todo *todo = [[self fetchedResultsController] objectAtIndexPath:indexPath];

        NSManagedObjectContext *managedObjectContext = [todo managedObjectContext];
        [managedObjectContext performWriteBlock:^{
            [managedObjectContext deleteObject:todo];
        }];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEditing]) {
        return UITableViewCellEditingStyleNone;
    }

    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Todo *todo = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    [[todo managedObjectContext] performWriteBlock:^{
        BOOL isComplete = [[todo complete] boolValue] == NO;
        [todo setComplete:@(isComplete)];
    }];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
