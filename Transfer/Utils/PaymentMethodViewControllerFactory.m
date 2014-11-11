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
#import "AdyenOpenSessionOperation.h"
#import <objc/runtime.h>

@implementation PaymentMethodViewControllerFactory

+(UIViewController*)viewControllerForPayInMethod:(PayInMethod*)method forPayment:(Payment*)payment objectModel:(ObjectModel*)objectModel;
{
    UIViewController* result;
    if([method.type caseInsensitiveCompare:@"DATA_CASH"] == NSOrderedSame)
    {
        CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
        [cardController setPayment:payment];
        
        cardController.initialRequestProvider = ^(LoadRequestBlock loadRequestBlock)
        {
            NSURLRequest* request = [TransferwiseOperation getRequestForApiPath:@"/card/pay" parameters:@{@"paymentId" : payment.remoteId}];
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
                [[GoogleAnalytics sharedInstance] sendScreen:@"Success"];
                [[GoogleAnalytics sharedInstance] sendPaymentEvent:@"PaymentMade" withLabel:@"debitcard_datacash"];
            } else {
                [[GoogleAnalytics sharedInstance] sendEvent:@"ErrorDebitCardPayment" category:@"Error" label:@""];
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.no.payment.title", nil)
                                                                   message:NSLocalizedString(@"upload.money.card.no.payment.message", nil)];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alertView show];
            }
        }];

        result = cardController;
    }
    else if([method.type caseInsensitiveCompare:@"ADYEN"] == NSOrderedSame)
    {
        CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
        [cardController setPayment:payment];
        __weak typeof (cardController) weakCardController = cardController;
        cardController.initialRequestProvider = ^(LoadRequestBlock loadRequestBlock)
        {
            AdyenOpenSessionOperation *operation = [AdyenOpenSessionOperation operationWithPaymentId:weakCardController.payment.remoteId resultHandler:^(NSError *error, NSURL *url) {
                NSURLRequest* request;
                
                if(url)
                {
                    request = [NSURLRequest requestWithURL:url];
                }
                else
                {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.no.payment.title", nil)
                                                                       message:NSLocalizedString(@"upload.money.card.no.adyen.url", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                }
                
                loadRequestBlock(request);
                objc_setAssociatedObject(weakCardController, @selector(operationWithPaymentId:resultHandler:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }];
            objc_setAssociatedObject(weakCardController, @selector(operationWithPaymentId:resultHandler:), operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [operation execute];
           
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
                [[GoogleAnalytics sharedInstance] sendScreen:@"Success"];
                [[GoogleAnalytics sharedInstance] sendPaymentEvent:@"PaymentMade" withLabel:@"debitcard_adyen"];
            } else {
                [[GoogleAnalytics sharedInstance] sendEvent:@"ErrorDebitCardPayment" category:@"Error" label:@""];
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.no.payment.title", nil)
                                                                   message:NSLocalizedString(@"upload.money.card.no.payment.message", nil)];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alertView show];
            }
        }];

        result = cardController;
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
