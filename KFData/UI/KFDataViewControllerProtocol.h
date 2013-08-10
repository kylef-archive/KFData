//
//  KFDataViewControllerProtocol.h
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <UIKit/UIKit.h>

@class KFDataStore;
@class NSManagedObjectContext;

@protocol KFDataViewControllerProtocol <NSObject>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext;

@end

@protocol KFDataDetailViewControllerProtocol <NSObject>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext;

@end

@protocol KFDataListViewControllerProtocol <NSObject>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext;

- (void)setFetchRequest:(NSFetchRequest*)fetchRequest
     sectionNameKeyPath:(NSString*)sectionNameKeyPath;

- (void)performFetch;

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
