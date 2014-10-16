//
//  PaymentsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel.h"
#import "ObjectModel+Payments.h"
#import "Payment.h"
#import "Constants.h"
#import "GoogleAnalytics.h"
#import "Mixpanel+Customisation.h"

NSString *const kPaymentsListPath = @"/payment/list";
NSUInteger kPaymentsListLimit = 20;

@interface PaymentsOperation ()

@property (nonatomic, assign) NSInteger offset;

@end

@implementation PaymentsOperation

- (id)initWithOffset:(NSInteger)offset {
    self = [super init];
    if (self) {
        _offset = offset;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kPaymentsListPath];

    __weak PaymentsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completion(0, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        //TODO jaanus: pull also recipient types here
        NSNumber *totalCount = response[@"total"];
        [weakSelf.objectModel saveInBlock:^(CDYObjectModel *objectModel) {
            ObjectModel *oModel = (ObjectModel *) objectModel;
            NSMutableArray *existingPaymentIds = [NSMutableArray arrayWithArray:[oModel listRemoteIdsForExistingPayments]];

            NSArray *payments = response[@"payments"];
            for (NSDictionary *data in payments) {
                Payment *payment = [oModel createOrUpdatePaymentWithData:data];
                [existingPaymentIds removeObject:payment.remoteId];
            }

            if (weakSelf.offset == 0)
			{
                MCLog(@"Have %lu remote id's after zero pull", (unsigned long)[existingPaymentIds count]);
                [oModel removePaymentsWithIds:existingPaymentIds];
            }
        } completion:^{
            [[GoogleAnalytics sharedInstance] markHasCompletedPayments];
            [[Mixpanel sharedInstance] registerSuperProperties:@{@"Hascompletepayment":[[GoogleAnalytics sharedInstance].objectModel hasAtLeastOneCompletePayment]?@"YES":@"NO"}];
            
            weakSelf.completion([totalCount integerValue], nil);
        }];
    }];

    [self getDataFromPath:path params:@{@"offset" : @(self.offset), @"limit" : @(kPaymentsListLimit)}];
}

+ (PaymentsOperation *)operationWithOffset:(NSInteger)offset {
    return [[PaymentsOperation alloc] initWithOffset:offset];
}

@end
