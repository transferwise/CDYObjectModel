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
#import "User.h"
@import PassKit;

#define kMinimumOSVersionForApplePay 8.1
#define kMinimumOSVersionForApplePayInSimulator 9.0

@interface ApplePayHelper ()

@property (nonatomic) ApplePayOperation *applePayOperation;

@end


@implementation ApplePayHelper

#pragma mark - Singleton

// Not sure whether we need this yet

+ (instancetype) sharedInstance
{
    static ApplePayHelper *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Apple Pay helpers

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
		// Only transfers of less than 2k are supported
        if(payment.sourceCurrency.code && [@"gbp" caseInsensitiveCompare: payment.sourceCurrency.code] == NSOrderedSame
		   && [payment.payIn floatValue] <= 2000)
        {
            // Check if ApplePay has been disabled via GTM
            if(![[NSUserDefaults standardUserDefaults] boolForKey:TRWDisableApplePay])
            {
                //these two checks can return different values
                if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks: self.supportedPaymentNetworks] == YES
                    && [PKPaymentAuthorizationViewController canMakePayments] == YES)
                {
                    // Pay is available
                    isAvailable = YES;
                }
            }
        }
    }
    
    return isAvailable;
}

#pragma mark - Apple Pay details

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
 *  Works out the country code for a particular payment
 *
 *  @param payment payment
 *
 *  @return Country code string
 */

- (NSString *) countryCodeForPayment: (Payment *) payment
{
    return @"GB";
    
    
    //Pretty certain this is the Merchant country, i.e. Transferwise's home: GB. Leaving the below code in so we can look again. m@s
    
    
//    NSString *countryCode;
//    
//    if (payment.businessProfileUsed)
//    {
//        countryCode = payment.user.businessProfile.countryCode;
//    }
//    else
//    {
//        countryCode = payment.user.personalProfile.countryCode;
//    }
//	
//	//ApplePay expects the country code to be ISO2, Payment contains ISO3
//	if ([@"gbr" caseInsensitiveCompare: countryCode] == NSOrderedSame)
//	{
//		return @"GB";
//	}
//	else if ([@"usa" caseInsensitiveCompare: countryCode] == NSOrderedSame)
//	{
//		return @"US";
//	}
//	else
//	{
//		return @"GB";
//	}
}

/**
 *  Create a PKPayment request suitable for ApplePay based on the current payment
 *
 *  @param payment Payment
 *
 *  @return A new PKPaymentRequest
 */

- (PKPaymentRequest *) createPaymentRequestForPayment: (Payment *) payment
{
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = ApplePayHelper.merchantId;
    request.supportedNetworks = ApplePayHelper.supportedPaymentNetworks;
    request.merchantCapabilities = PKMerchantCapability3DS; // Adyen supports only 3DS types
    
    request.countryCode = [self countryCodeForPayment: payment];
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
 *  Create either an authorizationViewController
 *
 *  @param paymentRequest The paymentRequest
 *
 *  @return The appropriate view controller
 */

- (UIViewController *) createAuthorizationViewControllerForPaymentRequest: (PKPaymentRequest *) paymentRequest
                                                                 delegate: (id<PKPaymentAuthorizationViewControllerDelegate>) delegate
{
	if (![PKPaymentAuthorizationViewController canMakePayments])
	{
		return nil;
	}
	
    PKPaymentAuthorizationViewController *paymentAuthorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];	
    paymentAuthorizationViewController.delegate = delegate;
	
    return paymentAuthorizationViewController;
}


- (void) sendToken: (PKPaymentToken *) paymentToken
      forPaymentId: (NSString *) paymentId
   responseHandler: (ApplePayTokenResponseBlock) responseHandler
{
    // Create additionalData section
    NSData *paymentData = paymentToken.paymentData;    
    NSString *tokenB64 = [paymentData base64EncodedStringWithOptions: 0];

    // Now create the network operation
    self.applePayOperation = [ApplePayOperation applePayOperationWithPaymentId: paymentId
                                                                      andToken: tokenB64];

    self.applePayOperation.responseHandler = responseHandler;
    
    // Start the operation
    [self.applePayOperation execute];

}
@end