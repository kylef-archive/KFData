//
//  TDTodoViewController.m
//  Todo
//
//  Created by Kyle Fuller on 20/12/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import "NSManagedObjectContext+KFData.h"
#import "NSManagedObject+KFData.h"
#import "TDTodoViewController.h"
#import "Todo.h"

@interface TDTodoViewController ()

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation TDTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Add Todo"];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done)];
    [[self navigationItem] setRightBarButtonItem:doneButton];

    UIBarButtonItem *cancelbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancel)];
    [[self navigationItem] setLeftBarButtonItem:cancelbutton];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    NSString *name = [[self textField] text];

    [[self managedObjectContext] performWriteBlock:^{
        Todo *todo = (Todo*)[Todo createInContext:[self managedObjectContext]];
        [todo setName:name];
        [todo setCreated:[NSDate date]];
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
