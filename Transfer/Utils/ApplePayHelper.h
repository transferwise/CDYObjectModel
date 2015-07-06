//
//  ApplePayHelper.h
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

@import Foundation;

@class Payment;
@class PKPaymentRequest;

@interface ApplePayHelper : NSObject

+ (NSArray *) supportedPaymentNetworks;
+ (NSString *) merchantId;
+ (BOOL) isApplePayAvailableForPayment: (Payment *) payment;
+ (PKPaymentRequest *) createPaymentRequestForPayment: (Payment *) payment;

@end
