# KFData

[![Build Status](https://travis-ci.org/kylef/KFData.png?branch=master)](https://travis-ci.org/kylef/KFData)

Core Data done right for iOS 5+/OS X 10.7+.

## Overview

KFData is a library for using Core Data, featuring many components which can be
used separately or together. 1.0 is a major update to this library, and we have
provided a
[migration guide](https://github.com/kylef/KFData/wiki/KFData-1.0-Migrations-Guide)
to help you migrate to the latest version.

### KFDataStore

`KFDataStore` is a component of KFData which is a wrapper around a Core Data
stack. Using the data store, you can create a Core Data stack in various
different configuration types.

Normally you would create a single `KFDataStore` across your whole application,
(or across a whole managed object model). You can call methods on a
`KFDataStore` instance to obtain a managed object context or perform
blocks of code with a background managed object context.

``` objective-c
KFDataStore *dataStore = [KFDataStore standardCloudDataStore];

// You can use helper methods to perform a write or read block
[dataStore performWriteBlock:^(NSManagedObjectContext*)managedObjectContext {
    Person *kylef = [Person createInManagedObjectContext:managedObjectContext];
    [kylef setName:@"Kyle Fuller"];
}];
```

### KFAttribute

Writing predicates and sort descriptors can often become cumbersome and hard
to manage. Since you need a string of the key value path of any attribute you
are trying to use. If you change the name or remove the attribute you will not
get compile time checks that "name" was removed from the Person entity.

To solve this problem KFData has created a class to deal with this. You can use
it as follows:

``` objective-c
NSPredicate *kylePredicate = [[Person name] equal:@"Kyle"];
// This will create a predicate which would be `"name == 'Kyle'"`.
```

You can even use the attribute in predicate formats:

``` objective-c
[NSPredicate predicateWithFormat:@"%K == %@", [Person name], @"Kyle"];
```

Your managed objects wont automatically implement these methods. So you will
either need to manually add them to a subclass, or alternatively you can use
our Python tool to generate your managed object implementation files.
Instructions on the Python tool can be found
[here](https://github.com/kylef/KFData.py), this tool is still in active
development so it may not be ready just yet.

There is another alternative, you won't get autocompletion or 100% correct
compile time checks. However we provide a macro which can provide some checks
providing you have the "Strict selector matching" warning enabled. This is with
a macro, which can be used as follows:

```objective-c
NSPredicate *predicate = [KFAttributeFromKey(name) equal:@"Kyle"];
```

### KFObjectManager

KFData also provides a helper class to create fetch requests and perform
various methods.

For example, to iterate over all people with an age greater than 21 you can do
the following:

``` objective-c
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K > 21", [Person age]];
KFObjectManager *manager = [[Person managedInManagedObjectContext:context] filter:predicate];

NSLog(@"All people over 21:");

for (Person *person in manager) {
    NSLog(@"- %@", person);
}
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

## Documentation

There is full documentation for KFData, it can either be found on
[CocoaDocs](http://cocoadocs.org/docsets/KFData) or within the headers of KFData.

## Contributing

Please see our [contributing](CONTRIBUTING.md) guide for details.

## License

KFData is released under the BSD license. See [LICENSE](LICENSE).

