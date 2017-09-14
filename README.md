# KFData

[![Build Status](http://img.shields.io/travis/kylef/KFData.svg?style=flat)](https://travis-ci.org/kylef/KFData)

Core Data done right for iOS 5+/OS X 10.7+.

## Current Status

As of iOS 10 and macOS 10.12, a lot of functionality from KFData is now available in CoreData directly. For any new development I'd recomment using [`NSPersistentContainer`](https://developer.apple.com/documentation/coredata/nspersistentcontainer?preferredLanguage=occ) and [QueryKit](https://github.com/querykit/querykit) directly.

- KFDataStore has been superceeded by [`NSPersistentContainer`](https://developer.apple.com/documentation/coredata/nspersistentcontainer?preferredLanguage=occ). `NSPersistentContainer` simplifies the creation and management of the Core Data stack just like KFDataStore.
- KFAttribute/KFManager has been superceeded by [QueryKit](https://github.com/querykit/querykit).

## Overview

KFData is a library for using Core Data, featuring many components which can be
used separately or together. 1.0 is a major update to this library, and we have
provided a
[migration guide](https://github.com/kylef/KFData/wiki/KFData-1.0-Migrations-Guide)
to help you migrate to the latest version.

### KFDataStore

#### NSPersistentContainer

As of iOS 10, macOS 10.12, Apple have introduced `NSPersistentContainer`
which aims to solve the same problems as KFDataStore. It is recommended
to migrate to [`NSPersistentContainer`](https://developer.apple.com/documentation/coredata/nspersistentcontainer?preferredLanguage=occ).

---

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

### KFAttribute and KFObjectManager

KFData used to provide two classes KFAttribute and KFObjectManager which are
now superseded by [QueryKit](https://github.com/QueryKit/QueryKit).

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add
KFData to your project.

Here's an example podfile that installs KFData.

### Podfile

Due to differences with framework headers. If you are using KFData as a framework, use 1.1.1 otherwise 1.1.0.

```ruby
platform :ios, '5.0'
use_frameworks!
pod 'KFData', '1.1.1'
```

```ruby
platform :ios, '5.0'

pod 'KFData', '1.1.0'
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

