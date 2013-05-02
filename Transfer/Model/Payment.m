//
//  Payment.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Payment.h"

@interface Payment ()

@property (nonatomic, strong) NSNumber *paymentId;
@property (nonatomic, copy) NSString *status;

@end

@implementation Payment

+ (Payment *)paymentWithData:(NSDictionary *)data {
    Payment *payment = [[Payment alloc] init];

    //{"limit_rate":"1.14711","payment_fee":"4.98","pay_in":"1000.00","matched_percent":"0.0","recipient_id":null,"submitted_date":"2013-05-02 09:41:01","received_date":"","transferred_date":"","cancelled_date":"","payment_reference":"","refund_recipient_id":""}
    [payment setPaymentId:data[@"id"]];
    [payment setStatus:data[@"payment_status"]];

    return payment;
}

- (NSString *)localizedStatus {
    NSString *statusKey = [NSString stringWithFormat:@"payment.status.%@.description", self.status];
    return NSLocalizedString(statusKey, nil);
}

@end
