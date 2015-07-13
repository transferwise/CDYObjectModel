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
#import "TransferwiseOperation.h"
#import "TRWProgressHUD.h"
#import "PullPaymentDetailsOperation.h"
#import "GoogleAnalytics.h"
#import "ClaimAccountViewController.h"
#import "Credentials.h"
#import "FeedbackCoordinator.h"
#import "SupportCoordinator.h"
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
    NSArray *availableOptions = self.forcedMethod ? @[self.forcedMethod] : [[self.payment enabledPayInMethods] array];
	
    for(id method in availableOptions)
    {
		NSString *type;
		
		if ([method isKindOfClass:[PayInMethod class]])
		{
			type = ((PayInMethod *)method).type;
		}
		else
		{
			//naively expect this to be NSString
			type = method;
		}
		
        UIViewController *controller = [PaymentMethodViewControllerFactory viewControllerForPayInMethod:method
																							 forPayment:self.payment
																							objectModel:self.objectModel];
        if(controller)
        {
            [viewControllers addObject:controller];
            NSString *currencyTitleKey = [NSString stringWithFormat:@"payment.method.%@.%@",type,self.payment.sourceCurrency.code];
            NSString *titleKey = [NSString stringWithFormat:@"payment.method.%@",type];
            NSString* title = [NSString localizedStringForKey:currencyTitleKey withFallback:NSLocalizedString(titleKey, nil)];
            [titles addObject:title];
        }
    }
    
    
    if([viewControllers count] == 1)
    {
        PayInMethod* method = availableOptions[0];
        NSString* key = [NSString stringWithFormat:@"payment.method.title.%@", method.type];
        [self setTitle:[NSString localizedStringForKey:[NSString stringWithFormat:@"%@.%@",key,self.payment.sourceCurrency.code] withFallback:key]];
    }
    else
    {
        [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
    }
    
    [super configureWithControllers:viewControllers
                             titles:titles
                        actionTitle:NSLocalizedString(@"transferdetails.controller.button.support",nil)
						actionStyle:@"blueButton"
					   actionShadow:nil
					 actionProgress:0.f];
					
    [super viewDidLoad];

    
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
    [[GoogleAnalytics sharedInstance] sendAppEvent:GAContactsupport withLabel:NSStringFromClass([[self.childViewControllers firstObject] class])];
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
