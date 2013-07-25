//
//  ObjectModel+PendingPayments.m
//  Transfer
//
//  Created by Jaanus Siim on 7/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "ObjectModel+Users.h"

@implementation ObjectModel (PendingPayments)

- (PendingPayment *)createPendingPayment {
    PendingPayment *existing = [self pendingPayment];
    if (existing) {
        [self deleteObject:existing saveAfter:NO];
    }

    PendingPayment *payment = [PendingPayment insertInManagedObjectContext:self.managedObjectContext];
    [payment setUser:[self currentUser]];

    return payment;
}

- (PendingPayment *)pendingPayment {
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self currentUser]];
    return [self fetchEntityNamed:[PendingPayment entityName] withPredicate:userPredicate];
}

@end
