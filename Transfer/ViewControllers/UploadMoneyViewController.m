//
//  UploadMoneyViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UploadMoneyViewController.h"
#import "Payment.h"
#import "ObjectModel.h"
#import "BankTransferViewController.h"
#import "TransferBackButtonItem.h"
#import "CardPaymentViewController.h"
#import "PaymentMethodSelectionView.h"
#import "UIView+Loading.h"
#import "TRWAlertView.h"
#import "PaymentDetailsViewController.h"
#import "TransferwiseOperation.h"
#import "TRWProgressHUD.h"
#import "PullPaymentDetailsOperation.h"
#import "GoogleAnalytics.h"
#import "ClaimAccountViewController.h"
#import "Credentials.h"
#import "FeedbackCoordinator.h"
#import "SupportCoordinator.h"
#import "TransferDetailsViewController.h"
#import "PaymentMethodViewControllerFactory.h"
#import "PayInMethod.h"
#import "NSString+Presentation.h"
#import "Currency.h"

@interface UploadMoneyViewController ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@end

@implementation UploadMoneyViewController

- (void)viewDidLoad
{
	self.showButtonForIphone = YES;
	
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSArray *availableOptions = self.forcedMethod?@[self.forcedMethod]:[[self.payment enabledPayInMethods] array];
    for(PayInMethod *method in availableOptions)
    {
        UIViewController *controller = [PaymentMethodViewControllerFactory viewControllerForPayInMethod:method forPayment:self.payment objectModel:self.objectModel];
        if(controller)
        {
            [viewControllers addObject:controller];
            NSString *currencyTitleKey = [NSString stringWithFormat:@"payment.method.%@.%@",method.type,self.payment.sourceCurrency.code];
            NSString *titleKey = [NSString stringWithFormat:@"payment.method.%@",method.type];
            NSString* title = [NSString localizedStringForKey:currencyTitleKey withFallback:NSLocalizedString(titleKey, nil)];
            [titles addObject:title];
        }
    }
    
    [self setTitle:[viewControllers count]>1?NSLocalizedString(@"upload.money.title", @""):NSLocalizedString(@"upload.money.title.single.method",nil)];
    
    [super configureWithControllers:viewControllers
                             titles:titles
                        actionTitle:NSLocalizedString(@"transferdetails.controller.button.support",nil)
						actionStyle:@"blueButton"
					   actionShadow:nil
					 actionProgress:0.f];
					
    [super viewDidLoad];

    
}

- (void)willSelectViewController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if([controller isKindOfClass:[CardPaymentViewController class]])
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Debit card payment"];
	}
	else if([controller isKindOfClass:[BankTransferViewController class]])
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Bank transfer payment"];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.navigationItem.leftBarButtonItem)
    {
        [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
		}]];
    }
}


- (void)actionTappedWithController:(UIViewController *)controller atIndex:(NSUInteger)index
{
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
