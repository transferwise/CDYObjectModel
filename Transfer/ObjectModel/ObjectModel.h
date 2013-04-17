//
//  ObjectModel.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectModel : NSObject

- (NSFetchedResultsController *)fetchedControllerForEntity:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
- (void)saveContext;

@end
