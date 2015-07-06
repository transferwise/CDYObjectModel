//
//  ApplePayHelper.m
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayHelper.h"
#import "Payment.h"
#import "Currency.h"
@import PassKit;

#define kMinimumOSVersionForApplePay 8.1

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

+ (PKPaymentRequest *) createPaymentRequestForPayment: (Payment *) payment
{
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = self.merchantId;
    request.supportedNetworks = self.supportedPaymentNetworks;
    request.merchantCapabilities = PKMerchantCapability3DS; // Adyen supports only 3DS types
    request.countryCode = @"GB";    // ISO 3166-1 alpha-2 country code - Merchant country code (!)
    request.currencyCode = @"GBP";  // ISO 4217 currency code
    
    // Convert our payment account from a string to an NSDecimalNumber (required for accuracy reasons)
    NSString *paymentAmountString = [payment payInString];
    NSDecimalNumber *totalAmount = [NSDecimalNumber decimalNumberWithString: paymentAmountString];
    
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel: @"Total"
                                                                          amount: totalAmount];
    request.paymentSummaryItems = @[totalItem];
    
    return request;
}





@end
