//
//  KFDataViewController.h
//  
//
//  Created by Kyle Fuller on 20/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "KFDataViewControllerProtocol.h"

@interface KFDataViewController : UIViewController <KFDataViewControllerProtocol>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
