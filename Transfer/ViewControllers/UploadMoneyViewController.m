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

@interface UploadMoneyViewController ()

@property (nonatomic, strong) BankTransferViewController *bankViewController;
@property (nonatomic, strong) CardPaymentViewController *cardViewController;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@end

@implementation UploadMoneyViewController

- (void)viewDidLoad
{
	[self initControllers];
	[super configureWithControllers:@[self.cardViewController, self.bankViewController]
							 titles:@[NSLocalizedString(@"payment.method.card", nil), NSLocalizedString(@"payment.method.regular", nil)]
						actionTitle:NSLocalizedString(@"transferdetails.controller.button.support",nil)
						actionStyle:@"blueButton"
					 actionProgress:0.f];
					
    [super viewDidLoad];

    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
}

- (void)initControllers
{
	CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
    [self setCardViewController:cardController];
    [cardController setPayment:self.payment];
    __weak typeof(self) weakSelf = self;
    [cardController setResultHandler:^(BOOL success) {
        if (success) {
            [[GoogleAnalytics sharedInstance] sendScreen:@"Success"];
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"PaymentMade" withLabel:@"debitcard"];
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.payment.success.title", nil)
                                                               message:NSLocalizedString(@"upload.money.card.payment.success.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.continue", nil) action:^{
                [weakSelf pushNextScreen];
                [[FeedbackCoordinator sharedInstance] startFeedbackTimerWithCheck:^BOOL {
                    return YES;
                }];
            }];
			
            [alertView show];
        } else {
            [[GoogleAnalytics sharedInstance] sendEvent:@"ErrorDebitCardPayment" category:@"Error" label:@""];
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.no.payment.title", nil)
                                                               message:NSLocalizedString(@"upload.money.card.no.payment.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			
            [alertView show];
        }
    }];
	
	BankTransferViewController *bankController = [[BankTransferViewController alloc] init];
    [bankController setPayment:self.payment];
    [bankController setObjectModel:self.objectModel];
    [self setBankViewController:bankController];
}

- (void)willSelectViewController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if(controller == self.cardViewController)
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Debit card payment"];
		[self.cardViewController loadCardView];
	}
	else if(controller == self.bankViewController)
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Bank transfer payment"];
		self.bankViewController.tableView.contentInset = IPAD?UIEdgeInsetsMake(55, 0, 0, 0):UIEdgeInsetsMake(20, 0, 50, 0);
		[self.bankViewController.tableView setContentOffset:CGPointMake(0,-self.bankViewController.tableView.contentInset.top)];
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

- (void)pushNextScreen {
	dispatch_async(dispatch_get_main_queue(), ^{
        //TODO jaanus: copy/paste from BankTransferScreen
        if ([Credentials temporaryAccount]) {
            ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self pushUpdatedTransactionScreen];
        }
	});
}

- (void)pushUpdatedTransactionScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.executedOperation) {
            return;
        }

        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"upload.money.refreshing.payment.message", nil)];
        PullPaymentDetailsOperation *operation = [PullPaymentDetailsOperation operationWithPaymentId:[self.payment remoteId]];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        __weak typeof(self) weakSelf = self;
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                [weakSelf setExecutedOperation:nil];

                if (error) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.transaction.refresh.error.title", nil) message:NSLocalizedString(@"upload.money.transaction.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }

                PaymentDetailsViewController *controller = [[PaymentDetailsViewController alloc] init];
                [controller setObjectModel:weakSelf.objectModel];
                [controller setPayment:(Payment *) [weakSelf.objectModel.managedObjectContext objectWithID:weakSelf.payment.objectID]];
                [controller setShowContactSupportCell:YES];
                [controller setFlattenStack:YES];
                [weakSelf.navigationController pushViewController:controller animated:YES];

            });
        }];

        [operation execute];
    });
}

- (void)actionTappedWithController:(UIViewController *)controller atIndex:(NSUInteger)index
{
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
