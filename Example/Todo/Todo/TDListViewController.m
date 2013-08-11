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

    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addTodo)];
    [[self navigationItem] setRightBarButtonItem:addButton];

    NSFetchRequest *fetchRequest = [Todo requestAllInManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setSortDescriptors:@[
        [[Todo created] ascending],
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Todo *todo = (Todo *)[self objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    [[cell textLabel] setText:[todo name]];

    if ([[todo complete] boolValue]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

#pragma mark - Delete

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Todo *todo = (Todo *)[self objectAtIndexPath:indexPath];
        NSManagedObjectContext *managedObjectContext = [todo managedObjectContext];

        [managedObjectContext deleteObject:todo];
        NSError *error;
        if ([managedObjectContext save:&error] == NO) {
            NSLog(@"Failed to delete Todo, we might want to tell the user.");
        }
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
    Todo *todo = (Todo *)[self objectAtIndexPath:indexPath];

    BOOL isComplete = [[todo complete] boolValue] == NO;
    [todo setComplete:@(isComplete)];

    NSError *error;
    if ([[todo managedObjectContext] save:&error] == NO) {
        NSLog(@"Failed to update Todo, we might want to tell the user.");
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
