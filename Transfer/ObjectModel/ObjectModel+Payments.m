//
//  ObjectModel+Payments.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Payments.h"
#import "Payment.h"
#import "NSDictionary+Cleanup.h"
#import "ObjectModel+Currencies.h"
#import "ObjectModel+Recipients.h"
#import "NSDate+ServerTime.h"
#import "Constants.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+PayInMethod.h"
#import "Credentials.h"
#import "PaymentMadeIndicator.h"

@implementation ObjectModel (Payments)

- (NSArray *)allPayments
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"remoteId" ascending:NO];
    NSPredicate *presentablePredicate = [NSPredicate predicateWithFormat:@"presentable = YES"];
	return [self fetchEntitiesNamed:[Payment entityName] usingPredicate:presentablePredicate withSortDescriptors:@[sortDescriptor]];
}

- (Payment *)paymentWithId:(NSNumber *)paymentId {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId = %@", paymentId];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self currentUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[remoteIdPredicate, userPredicate]];
    return [self fetchEntityNamed:[Payment entityName] withPredicate:predicate];
}

-(PaymentMadeIndicator*)paymentMadeIndicatorForPayment:(Payment*)payment
{
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"paymentRemoteId = %@", payment.remoteId];
    return [self fetchEntityNamed:[PaymentMadeIndicator entityName] withPredicate:remoteIdPredicate];
}

- (Payment *)createOrUpdatePaymentWithData:(NSDictionary *)rawData {
    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSNumber *paymentId = data[@"id"];
    Payment *payment = [self paymentWithId:paymentId];
    if (!payment) {
        payment = [Payment insertInManagedObjectContext:self.managedObjectContext];
        [payment setRemoteId:paymentId];
        [payment setUser:[self currentUser]];
    }

    [payment setPaymentStatus:data[@"paymentStatus"]];
    [payment setSourceCurrency:[self currencyWithCode:data[@"sourceCurrency"]]];
    [payment setTargetCurrency:[self currencyWithCode:data[@"targetCurrency"]]];
    [payment setPayIn:data[@"payIn"]];
    [payment setRecipient:[self createOrUpdateRecipientWithData:data[@"recipient"] hideCreted:YES]];
    NSDictionary *refund = data[@"refundRecipient"];
    if (refund) {
        [payment setRefundRecipient:[self createOrUpdateRecipientWithData:refund hideCreted:YES]];
    }
    [payment setSubmittedDate:[NSDate dateFromServerString:data[@"submittedDate"]]];
    [payment setReceivedDate:[NSDate dateFromServerString:data[@"receivedDate"]]];
    [payment setTransferredDate:[NSDate dateFromServerString:data[@"transferredDate"]]];
    [payment setCancelledDate:[NSDate dateFromServerString:data[@"cancelledDate"]]];
    [payment setEstimatedDelivery:[NSDate dateFromServerString:data[@"estimatedDelivery"]]];
    [payment setEstimatedDeliveryStringFromServer:data[@"formattedEstimatedDelivery"]];
    [payment setPayInMethods:[self createPayInMethodsWithData:data[@"payInMethods"]]];
    [payment setConversionRate:data[@"conversionRate"]];
    [payment setPayOut:data[@"payOut"]];
    [payment setProfileUsed:data[@"profile"]];
    [payment setPresentableValue:YES];
    
    PaymentMadeIndicator* indicator = [self paymentMadeIndicatorForPayment:payment];
    if(indicator)
    {
        if(payment.status == PaymentStatusSubmitted || payment.status == PaymentStatusUserHasPaid)
        {
            payment.paymentMadeIndicator = indicator;
        }
        else
        {
            [self deleteObject:indicator];
        }
    }

    return payment;
}

- (NSArray *)listRemoteIdsForExistingPayments {
    return [self fetchAttributeNamed:@"remoteId" forEntity:[Payment entityName]];
}

- (void)removePaymentsWithIds:(NSArray *)array {
    NSArray *payments = [self paymentsWithRemoteIds:array];
    MCLog(@"Will remove %d payments", [payments count]);
    [self deleteObjects:payments saveAfter:NO];
}

- (BOOL)hasCompletedPayments {
    if (![Credentials userLoggedIn]) {
        return NO;
    }

    NSPredicate *completedPredicate = [NSPredicate predicateWithFormat:@"paymentStatus = %@", @"transferred"];
    return [self countInstancesOfEntity:[Payment entityName] withPredicate:completedPredicate] > 0;
}

- (NSArray *)paymentsWithRemoteIds:(NSArray *)array {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId IN %@", array];
    return [self fetchEntitiesNamed:[Payment entityName] withPredicate:remoteIdPredicate];
}

-(void)togglePaymentMadeForPayment:(Payment*)payment
{
    PaymentMadeIndicator* indicator = payment.paymentMadeIndicator;
    if (indicator)
    {
        [self deleteObject:indicator];
    }
    else
    {
        indicator = [PaymentMadeIndicator insertInManagedObjectContext:self.managedObjectContext];
        indicator.paymentRemoteId = payment.remoteId;
        payment.paymentMadeIndicator = indicator;
    }
}

@end
