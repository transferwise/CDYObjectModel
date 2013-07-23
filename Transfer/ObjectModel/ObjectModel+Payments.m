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

@implementation ObjectModel (Payments)

- (NSFetchedResultsController *)fetchedControllerForAllPayments {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"submittedDate" ascending:NO];
    return [self fetchedControllerForEntity:[Payment entityName] predicate:nil sortDescriptors:@[sortDescriptor]];
}

- (Payment *)paymentWithId:(NSNumber *)paymentId {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId = %@", paymentId];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self currentUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[remoteIdPredicate, userPredicate]];
    return [self fetchEntityNamed:[Payment entityName] withPredicate:predicate];
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
    //TODO jaanus: hide this recipient if just created
    [payment setRecipient:[self createOrUpdateRecipientWithData:data[@"recipient"]]];
    [payment setSubmittedDate:[NSDate dateFromServerString:data[@"submittedDate"]]];
    [payment setReceivedDate:[NSDate dateFromServerString:data[@"receivedDate"]]];
    [payment setTransferredDate:[NSDate dateFromServerString:data[@"transferredDate"]]];
    [payment setCancelledDate:[NSDate dateFromServerString:data[@"cancelledDate"]]];
    [payment setEstimatedDelivery:[NSDate dateFromServerString:data[@"estimatedDelivery"]]];
    [payment setSettlementRecipient:[self createOrUpdateSettlementRecipientWithData:data[@"settlementRecipient"]]];

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

- (NSArray *)paymentsWithRemoteIds:(NSArray *)array {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId IN %@", array];
    return [self fetchEntitiesNamed:[Payment entityName] withPredicate:remoteIdPredicate];
}

@end
