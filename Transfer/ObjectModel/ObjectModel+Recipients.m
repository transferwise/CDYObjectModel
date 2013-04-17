//
//  ObjectModel+Recipients.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Recipients.h"
#import "Recipient.h"

@implementation ObjectModel (Recipients)

- (NSFetchedResultsController *)fetchedControllerForAllRecipients {
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    return [self fetchedControllerForEntity:[Recipient entityName] sortDescriptors:@[nameSortDescriptor]];
}

@end
