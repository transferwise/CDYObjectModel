//
//  Payment.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Payment.h"
#import "Recipient.h"

@interface Payment ()

@property (nonatomic, strong) NSNumber *paymentId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;
@property (nonatomic, strong) NSNumber *priority;
@property (nonatomic, strong) NSNumber *limitRate;
@property (nonatomic, strong) NSNumber *paymentFee;
@property (nonatomic, strong) NSNumber *payIn;
@property (nonatomic, strong) NSNumber *matchedPercent;
@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) NSDate *submittedDate;
@property (nonatomic, strong) NSDate *receivedDate;
@property (nonatomic, strong) NSDate *transferredDate;
@property (nonatomic, strong) NSDate *cancelledDate;
@property (nonatomic, copy) NSString *paymentReference;
@property (nonatomic, strong) Recipient *refundRecipient;
@property (nonatomic, strong) NSDate *estimatedDelivery;
@property (nonatomic, strong) Recipient *settlementRecipient;

@end

@implementation Payment

+ (Payment *)paymentWithData:(NSDictionary *)data {
    Payment *payment = [[Payment alloc] init];

    [payment setPaymentId:data[@"id"]];
    [payment setStatus:data[@"paymentStatus"]];
    [payment setSourceCurrency:data[@"sourceCurrency"]];
    [payment setTargetCurrency:data[@"targetCurrency"]];
    [payment setPriority:data[@"priority"]];
    [payment setLimitRate:data[@"limitRate"]];
    [payment setPaymentFee:data[@"paymentFee"]];
    [payment setPayIn:data[@"payIn"]];
    [payment setMatchedPercent:data[@"matchedPercent"]];
    [payment setRecipient:[Recipient recipientWithData:data[@"recipient"]]];
    [payment setSubmittedDate:[Payment dateFromString:data[@"submittedDate"]]];
    [payment setReceivedDate:[Payment dateFromString:data[@"receivedDate"]]];
    [payment setTransferredDate:[Payment dateFromString:data[@"transferredDate"]]];
    [payment setCancelledDate:[Payment dateFromString:data[@"cancelledDate"]]];
    [payment setPaymentReference:data[@"paymentReference"]];
    [payment setRefundRecipient:[Recipient recipientWithData:data[@"refundRecipient"]]];
    [payment setEstimatedDelivery:[Payment dateFromString:data[@"estimatedDelivery"]]];
    [payment setSettlementRecipient:[Recipient recipientWithData:data[@"settlementRecipient"]]];

    return payment;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.status];
    return NSLocalizedString(statusKey, nil);
}

- (NSString *)recipientName {
    return [self.recipient name];
}

- (NSString *)transferredAmountString {
    return [NSString stringWithFormat:@"%@ %@ > %@", self.payIn, self.sourceCurrency, self.targetCurrency];
}

static NSDateFormatter *__dateFormatter;
+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!dateString || [dateString isKindOfClass:[NSNull class]]) {
        return nil;
    }

    if (!__dateFormatter) {
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    return [__dateFormatter dateFromString:dateString];
}

@end
