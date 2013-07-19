//
//  ObjectModel+Users.h
//  Transfer
//
//  Created by Jaanus Siim on 7/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class User;
@class Currency;

@interface ObjectModel (Users)

- (void)createOrUpdateUserWithData:(NSDictionary *)data;
- (User *)currentUser;
- (NSFetchedResultsController *)fetchedControllerForRecipientsWithCurrency:(Currency *)currency;

@end
