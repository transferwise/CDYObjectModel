//
//  ApplePayHelper.h
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Transferwise. All rights reserved.
//
//  Helper for Apple pay, keeping all of the tricky code out of the view controller

@import Foundation;

// Forward class declarations
@class Payment;
@class PKPaymentRequest;

// Forward protocol declarations
@protocol PKPaymentAuthorizationViewControllerDelegate;

@interface ApplePayHelper : NSObject

+ (NSArray *) supportedPaymentNetworks;
+ (NSString *) merchantId;
+ (BOOL) isApplePayAvailableForPayment: (Payment *) payment;
+ (PKPaymentRequest *) createPaymentRequestForPayment: (Payment *) payment;
+ (UIViewController *) createAuthorizationViewControllerForPaymentRequest: (PKPaymentRequest *) paymentRequest
                                                                 delegate: (UIViewController<PKPaymentAuthorizationViewControllerDelegate> *) delegate;

@end
