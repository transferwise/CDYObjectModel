//
//  ObjectModel+PendingPayments.h
//  Transfer
//
//  Created by Jaanus Siim on 7/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class PendingPayment;

@interface ObjectModel (PendingPayments)

- (void)createPendingPayment;
- (PendingPayment *)pendingPayment;

@end
