//
//  KFDataTableViewController.h
//  KFData
//
//  Created by Kyle Fuller on 08/11/2012.
//  Copyright (c) 2012-2013 Kyle Fuller. All rights reserved.
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class KFObjectManager;
@class KFDataTableViewDataSource;

/**
 KFDataTableViewController is a generic controller base that manages a table
 view from a NSFetchRequest.

 It will automatically insert or update cells when changes have been made to
 the NSFetchRequest.
*/

@interface KFDataTableViewController : UITableViewController

@property (nonatomic, strong, readonly) KFDataTableViewDataSource *dataSource;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                      cacheName:(NSString *)cacheName;

- (void)setObjectManager:(KFObjectManager *)objectManager
      sectionNameKeyPath:(NSString *)sectionNameKeyPath
               cacheName:(NSString *)cacheName;

- (BOOL)performFetch:(NSError **)error;

- (UITableViewCell *)dataSource:(KFDataTableViewDataSource *)dataSource cellForManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath;

@end

#endif
