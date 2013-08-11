//
//  KFData.h
//  KFData
//
//  Created by Kyle Fuller on 09/04/2013.
//
//

#ifndef _KFDATA_
    #define _KFDATA_

    #import "KFDataStore.h"

    #import "KFAttribute.h"

    #import "NSManagedObject+KFData.h"
    #import "NSManagedObject+Requests.h"
    #import "NSManagedObject+Finders.h"
    #import "NSManagedObject+Aggregation.h"

    #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        #import "KFDataViewControllerProtocol.h"
        #import "KFDataCollectionViewController.h"
        #import "KFDataTableViewController.h"
        #import "KFDataViewController.h"
        #import "KFSearchableTableViewController.h"
    #endif
#endif
