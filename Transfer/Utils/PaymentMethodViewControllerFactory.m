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
#import "FeedbackCoordinator.h"

@implementation PaymentMethodViewControllerFactory

+(UIViewController*)viewControllerForPayInMethod:(PayInMethod*)method forPayment:(Payment*)payment objectModel:(ObjectModel*)objectModel;
{
    UIViewController* result;
    if([method.type caseInsensitiveCompare:@"DATA_CASH"] == NSOrderedSame)
    {
        CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
        [cardController setPayment:payment];
        cardController.path = @"/card/pay";
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
        result = cardController;
    }
    else
    {
        BankTransferViewController *bankController = [[BankTransferViewController alloc] init];
        [bankController setPayment:payment];
        [bankController setObjectModel:objectModel];
        bankController.method = method;
        result = bankController;
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
