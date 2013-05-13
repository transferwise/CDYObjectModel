//
//  ObjectModel.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectModel : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (id)findEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)listEntitiesNamed:(NSString *)entityName;
- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
- (void)saveContext;
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObject:(NSManagedObject *)object saveAfter:(BOOL)saveAfter;

@end
