//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KFDataViewControllerProtocol.h"

/*
  KFDataTableViewController is a generic controller base that manages a table
  view from an NSFetchRequest.

  It implements the following:
 
    - If changes happen on the parent NSManagedObjectContext, they will be
      merged into the context for this view controller.
    - The table view is automatically updated to insert changes when changes
      have been made to the NSFetchRequest.
*/

@interface KFDataTableViewController : UITableViewController <KFDataViewControllerProtocol, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

@end

#endif
