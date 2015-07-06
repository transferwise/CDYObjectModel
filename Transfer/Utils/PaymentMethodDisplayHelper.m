//
//  PaymentMethodDisplayHelper.m
//  Transfer
//
//  Created by Nick Banks on 06/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodDisplayHelper.h"
#import "Payment.h"
#import "Currency.h"
#import "ApplePayHelper.h"

@implementation PaymentMethodDisplayHelper

/**
 *  Should we display an error page for this payment (due to no payin methods).  A bit trivial, but here for completeness
 *
 *  @param payment <#payment description#>
 *
 *  @return <#return value description#>
 */

+ (PaymentDisplayType) displayErrorForPayment: (Payment *) payment
{
    NSUInteger numberOfPayInMethods = [[payment enabledPayInMethods] count];
    
    return numberOfPayInMethods < 1 ? YES : NO;
}

/**
 *  Should we display the payment methods for this payment as tabs or a list,
 *
 *  @param payment The payment
 *
 *  @return enum value representing payment mechanism
 */

+ (PaymentDisplayType) displayMethodForPayment: (Payment *) payment
{
    NSUInteger numberOfPayInMethods = [[payment enabledPayInMethods] count];
    
    if(numberOfPayInMethods > 2
       || ([@"usd" caseInsensitiveCompare: [payment.sourceCurrency.code lowercaseString]] == NSOrderedSame && numberOfPayInMethods > 1)
       )
    {
        return kDisplayAsList;
    }
    else
    {
        return kDisplayAsTabs;
    }
}

@end

