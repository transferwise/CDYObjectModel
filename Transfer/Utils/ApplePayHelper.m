//
//  ApplePayHelper.m
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayHelper.h"
#import "BusinessProfile.h"
#import "Currency.h"
#import "Payment.h"
#import "PersonalProfile.h"
#import "STPTestPaymentAuthorizationViewController.h"
#import "User.h"
@import PassKit;

#define kMinimumOSVersionForApplePay 8.1
#define  kMinimumOSVersionForApplePayInSimulator 9.0

@implementation ApplePayHelper

/**
 *  Currently we support all networks
 *
 *  @return Array of card types
 */

+ (NSArray *) supportedPaymentNetworks
{
    return @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
}

/**
 *  The merchantId to use with apple pay
 *
 *  @return <#return value description#>
 */

+ (NSString *) merchantId
{
    // We might want to move this to the plist
    return @"merchant.com.transferwise.Transferwise";
}

/**
 *  Work out if we can actully use apply pay for this payment
 *
 *  @param payment The payment
 *
 *  @return YES if we can use Apple Pay
 */

+ (BOOL) isApplePayAvailableForPayment: (Payment *) payment
{
    BOOL isAvailable = NO;
    
    if (([UIDevice.currentDevice.systemVersion floatValue] >= kMinimumOSVersionForApplePay)) {
        // We can only currently pay wih Apple pay when using GBP
        if(payment.sourceCurrency.code && [@"gbp" caseInsensitiveCompare: payment.sourceCurrency.code] == NSOrderedSame)
        {
            if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks: self.supportedPaymentNetworks] == YES) {
                // Pay is available
                isAvailable = YES;
            }
        }
    }
    
    return isAvailable;
}

/**
 *  Create a PKPayment request suitable for ApplePay based on the current payment
 *
 *  @param payment Payment
 *
 *  @return A new PKPaymentRequest
 */

+ (PKPaymentRequest *) createPaymentRequestForPayment: (Payment *) payment
{
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = self.merchantId;
    request.supportedNetworks = self.supportedPaymentNetworks;
    request.merchantCapabilities = PKMerchantCapability3DS; // Adyen supports only 3DS types
   
    if (payment.businessProfileUsed)
    {
        request.countryCode = payment.user.businessProfile.countryCode;
    }
    else
    {
        request.countryCode = payment.user.personalProfile.countryCode;
    }
    
    request.currencyCode = payment.sourceCurrency.code;  // ISO 4217 currency code
    
    // Convert our payment account from a string to an NSDecimalNumber (required for accuracy reasons)
    NSString *paymentAmountString = [payment payInStringNoSpaces];
    NSDecimalNumber *totalAmount = [NSDecimalNumber decimalNumberWithString: paymentAmountString];
    
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel: @"Total"
                                                                          amount: totalAmount];
    request.paymentSummaryItems = @[totalItem];
    
    return request;
}

/**
 *  Create either a real or stub authorizationViewController depending on whether in Debug mode and what version of iOS we are running under
 *
 *  @param paymentRequest The paymentRequest
 *
 *  @return The appropriate view controller
 */

+ (UIViewController *) createAuthorizationViewControllerForPaymentRequest: (PKPaymentRequest *) paymentRequest
                                                                 delegate: (UIViewController<PKPaymentAuthorizationViewControllerDelegate>*) delegate
{
    UIViewController *paymentAuthorizationViewController;
    
#if DEBUG
    if (([UIDevice.currentDevice.systemVersion floatValue] >= kMinimumOSVersionForApplePayInSimulator))
    {
        paymentAuthorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
        ((PKPaymentAuthorizationViewController *)paymentAuthorizationViewController).delegate = delegate;
    }
    else
    {
        paymentAuthorizationViewController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
        ((STPTestPaymentAuthorizationViewController *)paymentAuthorizationViewController).delegate = delegate;
    }
#else
    paymentAuthorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
    ((PKPaymentAuthorizationViewController *)paymentAuthorizationViewController).delegate = delegate;
#endif
    
    return paymentAuthorizationViewController;
}

@end
