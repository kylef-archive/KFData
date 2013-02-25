## Overview

Normally you would create a single `KFDataStore` across your whole application,
(or across a whole managed object model). You can call methods on a
`KFDataStore` instance to create a `NSManagedObjectContext` or perform blocks
of code with a `NSManagedObjectContext`.

``` objective-c
KFDataStore *dataStore = [[KFDataStore alloc] init];

// You can use helper methods to perform a write or read block
[dataStore performWriteBlock:^(NSManagedObjectContext*)managedObjectContext {
    Person *kylef = [Person createInManagedObjectContext:managedObjectContext];
    [kylef setName:@"Kyle Fuller"];
}];
```

``` objective-c
// Get a NSManagedObjectContext for the data store
NSManagedObjectContext *managedObjectContext = [dataStore managedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

// This will return a child managed object context for our main managed
// object context.

// Perform some changes then save up to the main managed object context
[managedObjectContext performBlock:^{
    Person *kylef = [Person createInManagedObjectContext:managedObjectContext];
    [kylef setName:@"Kyle Fuller"];
    [managedObjectContext nestedSave];
}];
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add
KFData to your project.

Here's an example podfile that installs KFData.

### Podfile

```ruby
platform :ios, '5.0'

pod 'KFData'
```

Note the specification of iOS 5.0 as the platform; leaving out the 5.0 will
cause CocoaPods to fail with the following message:

> [!] KFData is not compatible with iOS 4.3.

## Contributing

Please see our [contributing](CONTRIBUTING.md) guide for details.

## License

KFData is released under the BSD license. See [LICENSE](LICENSE).

