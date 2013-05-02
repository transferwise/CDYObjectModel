//
//  ObjectModel.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"
#import "Constants.h"

@interface ObjectModel ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ObjectModel

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate {
    return [self fetchRequestForEntity:entity predicate:predicate sortDescriptors:nil];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchRequestForEntity:entity predicate:nil sortDescriptors:sortDescriptors];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

- (id)findEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:predicate];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        MCLog(@"Fetch error %@", error);
    }

    if ([objects count] > 1) {
        MCLog(@"%d objects for fetch with entity %@", [objects count], entityName);
    }

    return [objects lastObject];
}

- (NSArray *)listEntitiesNamed:(NSString *)entityName {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName predicate:nil];

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        MCLog(@"Fetch error %@", error);
    }

    MCLog(@"%d objects for fetch with entity %@", [objects count], entityName);
    return objects;
}

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName sortDescriptors:sortDescriptors];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:self.managedObjectContext
              sectionNameKeyPath:nil cacheName:nil];

    NSError *fetchError = nil;
    [controller performFetch:&fetchError];
    if (fetchError) {
        MCLog(@"Fetch error - %@", fetchError);
    }

    return controller;
}

- (void)deleteObject:(NSManagedObject *)object {
    [self deleteObject:object saveAfter:YES];
}

- (void)deleteObject:(NSManagedObject *)object saveAfter:(BOOL)saveAfter {
    [self.managedObjectContext deleteObject:object];

    if (!saveAfter) {
        return;
    }
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Transfer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Transfer.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        MCLog(@"Model error:%@", error);
        MCLog(@"==========================");
        MCLog(@"Warning: Will wipe old DB!");
        MCLog(@"==========================");
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        _persistentStoreCoordinator = nil;
        _managedObjectContext = nil;

        return [self persistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
