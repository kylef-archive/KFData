//
// NSManagedObjectContext+KFData.h
// KFData
//
// Created by Kyle Fuller on 26/11/2012
// Copyright (c) 2012 Kyle Fuller. All rights reserved
//

@interface NSManagedObjectContext (KFData)

// Save (returns if we saved or not)
- (BOOL)save;

// Save, and propergate changes up parent managed object contexts
- (BOOL)nestedSave;

// Asyncronously save
- (void)performSave;

// Asyncronous nested save
- (void)performNestedSave;

@end

