//
//  KFDataViewController.h
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#import "KFDataViewControllerProtocol.h"

@interface KFDataViewController : UIViewController <KFDataViewControllerProtocol>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end

#endif
