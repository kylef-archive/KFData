## Overview

Normally you would create a single `KFDataStore` across your whole application,
(or across a whole managed object model). You can call methods on a
`KFDataStore` instance to create a `NSManagedObjectContext` or perform blocks
of code with a `NSManagedObjectContext`.

``` objective-c
KFDataStore *dataStore = [[KFDataStore alloc] init];

// Get an NSManagedObjectContext for the data store
NSManagedObjectContext *managedObjectContext = [dataStore managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

// This will return a child managed object context for our main managed
// object context.

// Perform some changes then save up to the main managed object context
[managedObjectContext performBlock:^{
    Person *kylef = [Person createInManagedObjectContext:managedObjectContext];
    [kylef setName:@"Kyle Fuller"];
    [managedObjectContext nestedSave];
}];

// You can use helper methods to perform a write or read block
[dataStore performWriteBlock:^(NSManagedObjectContext*)managedObjectContext {
    Person *kylef = [Person createInManagedObjectContext:managedObjectContext];
    [kylef setName:@"Kyle Fuller"];
}];
```

## License

KFData is released under the BSD license. See
[LICENSE](https://github.com/kylef/KFData/blob/master/LICENSE).

