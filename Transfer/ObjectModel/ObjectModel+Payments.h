//
//  ObjectModel+Payments.h
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class Payment;

@interface ObjectModel (Payments)

- (NSFetchedResultsController *)fetchedControllerForAllPayments;
- (Payment *)createOrUpdatePaymentWithData:(NSDictionary *)rawData;
- (NSArray *)listRemoteIdsForExistingPayments;
- (void)removePaymentsWithIds:(NSArray *)array;

@end
