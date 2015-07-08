//
//  ApplePayHelper.m
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayHelper.h"
#import "ApplePayOperation.h"
#import "BusinessProfile.h"
#import "Currency.h"
#import "Payment.h"
#import "PersonalProfile.h"
#import "STPTestPaymentAuthorizationViewController.h"
#import "User.h"
@import PassKit;

#define kMinimumOSVersionForApplePay 8.1
#define  kMinimumOSVersionForApplePayInSimulator 9.0

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
    NSString *countryCode;
    
    if (payment.businessProfileUsed)
    {
        countryCode = payment.user.businessProfile.countryCode;
    }
    else
    {
        countryCode = payment.user.personalProfile.countryCode;
    }
    
    return countryCode;
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
    
#if DEBUG
    request.currencyCode = @"USD";
    request.countryCode = @"US";
#endif
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

- (UIViewController *) createAuthorizationViewControllerForPaymentRequest: (PKPaymentRequest *) paymentRequest
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


- (void) sendToken: (PKPaymentToken *) paymentToken
      forPaymentId: (NSString *) paymentId
{
    // Create additionalData section
    NSData *paymentData = paymentToken.paymentData;
    NSString *tokenB64 = [paymentData base64EncodedStringWithOptions: 0];

    // Now create the parameter dictionary
    NSDictionary* parameterDictionary = @{@"paymentId" : paymentId,
                                          @"paymentToken" : tokenB64};
    
    // Now create the network operation
    // + (ApplePayTokenOperation *) applePayOperationWithToken: (NSData *) token;
    
    self.applePayOperation = [ApplePayOperation applePayOperationWithParameterDictionary: parameterDictionary];
    
    __weak typeof(self) weakSelf = self;
    
    self.applePayOperation.responseHandler = ^(NSError* error, NSDictionary *result) {
        
        // Make sure we are on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    };

    // Start the operation
    [self.applePayOperation execute];

}

@end
