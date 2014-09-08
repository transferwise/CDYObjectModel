//
//  PaymentcancelOperation.m
//  Transfer
//
//  Created by Mats Trovik on 18/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentCancelOperation.h"
#import "Payment.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Payments.h"


NSString *const kPaymentCancelPath = @"/payment/cancel";

@interface PaymentCancelOperation ()

@property (nonatomic, strong) NSNumber *paymentId;

@end
@implementation PaymentCancelOperation



- (instancetype)initWithPaymentId:(NSNumber *)paymentId
{
    self = [super init];
    if (self) {
        _paymentId = paymentId;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kPaymentCancelPath];
    
    __block __weak PaymentCancelOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        if(weakSelf.responseHandler)
        {
            weakSelf.responseHandler(error);
        }
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        if(weakSelf.responseHandler)
        {
            weakSelf.responseHandler(nil);
        }
    }];
    
    [self postData:@{@"paymentId" : self.paymentId} toPath:path];
}

+ (instancetype)operationWithPayment:(Payment *)payment
{
   return [[PaymentCancelOperation alloc] initWithPaymentId:payment.remoteId];
}


@end
