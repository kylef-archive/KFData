//
//  KFObjectManager
//  KFData
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import "KFObjectManager.h"

@interface KFObjectManager ()

@end

@implementation KFObjectManager

#pragma mark - Creation

+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription {
    return [[self alloc] initWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:nil sortDescriptors:nil range:NSMakeRange(NSNotFound, NSNotFound)];
}

+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [[self alloc] initWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors range:NSMakeRange(NSNotFound, NSNotFound)];
}

+ (instancetype)managerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest {
    NSParameterAssert(fetchRequest != nil);

    NSEntityDescription *entityDescription = [fetchRequest entity];
    NSPredicate *predicate = [fetchRequest predicate];
    NSArray *sortDescriptors = [fetchRequest sortDescriptors];

    return [[self alloc] initWithManagedObjectContext:managedObjectContext entityDescription:entityDescription predicate:predicate sortDescriptors:sortDescriptors range:NSMakeRange(NSNotFound, NSNotFound)];
}

#pragma mark - Equality

- (BOOL)isEqualToManager:(KFObjectManager *)objectManager {
    return [self isEqualToQuerySet:objectManager];
}

@end
