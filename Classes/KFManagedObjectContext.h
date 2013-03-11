//
//  KFManagedObjectContext.h
//  KFData
//
//  Created by Kyle Fuller on 11/03/2013.
//
//

#import <CoreData/CoreData.h>

@interface KFManagedObjectContext : NSManagedObjectContext

@property (nonatomic, assign) BOOL mergeFromParentContext;

@end
