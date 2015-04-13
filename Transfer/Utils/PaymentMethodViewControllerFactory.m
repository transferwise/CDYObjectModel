//
//  PaymentMethodViewControllerFactory.m
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodViewControllerFactory.h"
#import "PayInMethod.h"
#import "CardPaymentViewController.h"
#import "BankTransferViewController.h"
#import "TRWAlertView.h"
#import "GoogleAnalytics.h"
#import "TransferwiseClient.h"
#import "Payment.h"
#import <objc/runtime.h>
#import "AchFlow.h"
#import "Mixpanel+Customisation.h"

@implementation PaymentMethodViewControllerFactory

+(UIViewController*)viewControllerForPayInMethod:(PayInMethod*)method forPayment:(Payment*)payment objectModel:(ObjectModel*)objectModel;
{
    UIViewController* result;
    if([@"DATA_CASH" caseInsensitiveCompare:method.type] == NSOrderedSame || [@"ADYEN" caseInsensitiveCompare:method.type] == NSOrderedSame)
    {
        BOOL isDataCash = [@"DATA_CASH" caseInsensitiveCompare:method.type] == NSOrderedSame;
        CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
        [cardController setPayment:payment];
        
        cardController.initialRequestProvider = ^(LoadRequestBlock loadRequestBlock)
        {
            NSURLRequest* request = [TransferwiseOperation getRequestForApiPath:@"/v2/card/pay" parameters:@{@"paymentId" : payment.remoteId}];
            loadRequestBlock(request);
        };
        
        cardController.loadURLBlock = ^(NSURL *url)
        {
            NSString *absoluteString = [url absoluteString];
            if ([absoluteString rangeOfString:@"/card/paidIn"].location != NSNotFound) {
                return URLActionAbortAndReportSuccess;
            } else if ([absoluteString rangeOfString:@"/card/notPaidIn"].location != NSNotFound) {
                return URLActionAbortAndReportFailure;
            } else if ([absoluteString rangeOfString:@"/payment/"].location != NSNotFound) {
                return URLActionAbortLoad;
            }
            
            return URLActionContinueLoad;
        };
        
        [cardController setResultHandler:^(BOOL success) {
            if (success) {
                NSString* methodName = isDataCash?@"debitcard_datacash":@"debitcard_adyen";
                [[GoogleAnalytics sharedInstance] sendScreen:GASuccess];
                [[GoogleAnalytics sharedInstance] sendPaymentEvent:GAPaymentmade withLabel:methodName];
                [[Mixpanel sharedInstance] track:MPPaymentmade properties:@{@"Payment Method":methodName}];
            } else {
                [[GoogleAnalytics sharedInstance] sendEvent:GAErrordebitcardpayment category:@"Error" label:isDataCash?@"debitcard_datacash":@"debitcard_adyen"];
            }
        }];

        result = cardController;
    }
    	else if ([@"ACH" caseInsensitiveCompare:method.type] == NSOrderedSame)
	{
		AchFlow *flow = [AchFlow sharedInstanceWithPayment:payment
											   objectModel:objectModel
											successHandler:^{
												[[GoogleAnalytics sharedInstance] sendPaymentEvent:GAPaymentmade
																						 withLabel:@"ACH"];
                                                [[Mixpanel sharedInstance] track:MPPaymentmade properties:@{@"Payment Method":@"ACH"}];
											}];
		return [flow getAccountAndRoutingNumberController];
	}
    else
    {
        BankTransferViewController *bankController = [[BankTransferViewController alloc] init];
        [bankController setPayment:payment];
        bankController.method = method;
        result = bankController;
    }
    
    if([result respondsToSelector:@selector(setObjectModel:)])
    {
        [result performSelector:@selector(setObjectModel:) withObject:objectModel];
    }
    
    NSString *title = [NSString stringWithFormat:@"payment.method.%@",method.type];
    result.title = NSLocalizedString(title,nil);
    if([result.title isEqualToString:title])
    {
        result.title = method.type;
    }
    return result;
}

@end
