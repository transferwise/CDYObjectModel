//
//  ObjectModel+Recipients.h
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class Recipient;
@class Currency;

@interface ObjectModel (Recipients)

- (NSFetchedResultsController *)fetchedControllerForAllUserRecipients;
- (Recipient *)createOrUpdateRecipientWithData:(NSDictionary *)data;
- (Recipient *)createOrUpdateSettlementRecipientWithData:(NSDictionary *)data;
- (Recipient *)createRecipient;
- (NSFetchedResultsController *)fetchedControllerForRecipientsWithCurrency:(Currency *)currency;

@end