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
        [cardController setResultHandler:^(BOOL success) {
            if (success) {
                [[GoogleAnalytics sharedInstance] sendScreen:@"Success"];
                [[GoogleAnalytics sharedInstance] sendPaymentEvent:@"PaymentMade" withLabel:@"debitcard"];
                [[FeedbackCoordinator sharedInstance] startFeedbackTimerWithCheck:^BOOL {
                    return YES;
                }];
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
