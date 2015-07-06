//
//  PaymentMethodDisplayHelper.h
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

@import Foundation;

@class Payment;

@interface PaymentMethodDisplayHelper : NSObject

typedef NS_ENUM(NSInteger, PaymentDisplayType) {
    kDisplayAsTabs,
    kDisplayAsList
};

+ (PaymentDisplayType) displayErrorForPayment: (Payment *) payment;
+ (PaymentDisplayType) displayMethodForPayment: (Payment *) payment;

@end
