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
#import "UINavigationController+StackManipulations.h"
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
#import "HeaderTabView.h"
#import "SupportCoordinator.h"

@interface UploadMoneyViewController ()<HeaderTabViewDelegate>

@property (nonatomic, strong) BankTransferViewController *bankViewController;
@property (nonatomic, strong) CardPaymentViewController *cardViewController;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic,weak) IBOutlet HeaderTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewHeightConstraint;
@property (nonatomic,weak) IBOutlet UIButton *contactButton;
@end

@implementation UploadMoneyViewController

- (id)init {
    self = [super initWithNibName:@"UploadMoneyViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];

    if ([self.payment multiplePaymentMethods]) {
        [self.tabView setTabTitles:@[NSLocalizedString(@"payment.method.card", nil), NSLocalizedString(@"payment.method.regular", nil)]];
        [self.tabView setSelectedIndex:0];
    }
    else
    {
        self.tabViewHeightConstraint.constant = 0;
    }
    
    CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
    [self setCardViewController:cardController];
    [self attachChildController:cardController];
    [cardController setPayment:self.payment];
    [cardController setResultHandler:^(BOOL success) {
        if (success) {
            [[GoogleAnalytics sharedInstance] sendScreen:@"Success"];
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"PaymentMade" withLabel:@"debitcard"];
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.payment.success.title", nil)
                                                               message:NSLocalizedString(@"upload.money.card.payment.success.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.continue", nil) action:^{
                [self pushNextScreen];
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
    [self attachChildController:bankController];
    [bankController setPayment:self.payment];
    [bankController setObjectModel:self.objectModel];
    [self setBankViewController:bankController];
    
    [self headerTabView:nil tabTappedAtIndex:0];
    
    [self.contactButton setTitle:NSLocalizedString(@"transferdetails.controller.button.support",nil) forState:UIControlStateNormal];

    
}


- (void)headerTabView:(HeaderTabView *)tabView tabTappedAtIndex:(NSUInteger)index {
    if (index == 1) {
        [[GoogleAnalytics sharedInstance] sendScreen:@"Bank transfer payment"];
        [self.containerView addSubview:self.bankViewController.view];
        [self.cardViewController.view removeFromSuperview];
    } else {
		[[GoogleAnalytics sharedInstance] sendScreen:@"Debit card payment"];
        [self.cardViewController loadCardView];
        [self.containerView addSubview:self.cardViewController.view];
        [self.bankViewController.view removeFromSuperview];
    }
}

- (void)attachChildController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [controller.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:controller.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
    }]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self.navigationController flattenStack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                [self setExecutedOperation:nil];

                if (error) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.transaction.refresh.error.title", nil) message:NSLocalizedString(@"upload.money.transaction.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }

                PaymentDetailsViewController *controller = [[PaymentDetailsViewController alloc] init];
                [controller setObjectModel:self.objectModel];
                [controller setPayment:(Payment *) [self.objectModel.managedObjectContext objectWithID:self.payment.objectID]];
                [controller setShowContactSupportCell:YES];
                [controller setFlattenStack:YES];
                [self.navigationController pushViewController:controller animated:YES];

            });
        }];

        [operation execute];
    });
}

- (IBAction)contactSupportPressed {
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
