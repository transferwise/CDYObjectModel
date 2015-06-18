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

- (NSArray *)allPayments;
- (Payment *)createOrUpdatePaymentWithData:(NSDictionary *)rawData;
- (Payment *)populatePayment:(Payment*)payment withData:(NSDictionary*)data;
- (NSArray *)listRemoteIdsForExistingPayments;
- (void)removePaymentsWithIds:(NSArray *)array;
- (BOOL)hasCompletedPayments;
- (NSArray *)paymentsWithRemoteIds:(NSArray *)array;
- (void)togglePaymentMadeForPayment:(Payment*)payment payInMethodName:(NSString*)payInMethodName;
- (BOOL)hasNoOrOnlyCancelledPaymentsExeptThis:(NSManagedObjectID *)paymentID;
- (Payment*)latestPayment;


@end
