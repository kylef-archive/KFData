//
//  TDListViewController.m
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import "KFDataTableViewDataSource.h"
#import "TDListViewController.h"
#import "TDTodoViewController.h"
#import "Todo.h"

@interface TDListViewController ()

@end

@implementation TDListViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Todo"];

    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addTodo)];
    [[self navigationItem] setRightBarButtonItem:addButton];

    KFObjectManager *manager = [Todo managerInManagedObjectContext:[self managedObjectContext]];
    [self setObjectManager:manager sectionNameKeyPath:nil cacheName:nil];
}

- (void)addTodo {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    UIViewController *addViewController = [[TDTodoViewController alloc] initWithManagedObjectContext:managedObjectContext];
    addViewController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:addViewController animated:YES completion:nil];
}

#pragma mark -

- (UITableViewCell *)dataSource:(KFDataTableViewDataSource *)dataSource cellForManagedObject:(Todo *)todo atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[dataSource tableView] dequeueReusableCellWithIdentifier:@"Cell"];

    [[cell textLabel] setText:[todo name]];

    if ([todo isComplete]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEditing]) {
        return UITableViewCellEditingStyleNone;
    }

    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Todo *todo = (Todo *)[[self dataSource] objectAtIndexPath:indexPath];

    BOOL isComplete = [[todo complete] boolValue] == NO;
    [todo setComplete:@(isComplete)];

    NSError *error;
    if ([[todo managedObjectContext] save:&error] == NO) {
        NSLog(@"Failed to update Todo, we might want to tell the user.");
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
