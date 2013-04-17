//
//  ObjectModel+Recipients.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (Recipients)

- (NSFetchedResultsController *)fetchedControllerForAllRecipients;

@end
