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

@interface UploadMoneyViewController ()

@property (nonatomic, strong) BankTransferViewController *bankViewController;
@property (nonatomic, strong) CardPaymentViewController *cardViewController;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

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

    CardPaymentViewController *cardController = [[CardPaymentViewController alloc] init];
    [self setCardViewController:cardController];
    [self attachChildController:cardController];
    [cardController setPayment:self.payment];
    [cardController setResultHandler:^(BOOL success) {
        if (success) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.payment.success.title", nil)
                                                               message:NSLocalizedString(@"upload.money.card.payment.success.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.continue", nil) action:^{
                [self pushNextScreen];
            }];

            [alertView show];
        } else {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.card.no.payment.title", nil)
                                                               message:NSLocalizedString(@"upload.money.card.no.payment.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];

            [alertView show];
        }
    }];

    BankTransferViewController *bankController = [[BankTransferViewController alloc] init];
    [self setBankViewController:bankController];
    [self attachChildController:bankController];
    [bankController setPayment:self.payment];
    [bankController setObjectModel:self.objectModel];
    [bankController setHideBottomButton:self.hideBottomButton];
    [bankController setShowContactSupportCell:self.showContactSupportCell];

    if ([self.payment multiplePaymentMethods]) {
        PaymentMethodSelectionView *selectionView = [PaymentMethodSelectionView loadInstance];
        [selectionView setSegmentChangeHandler:^(NSInteger selectedIndex) {
            [self selectionChangedToIndex:selectedIndex];
        }];
        [selectionView setTitles:@[NSLocalizedString(@"payment.method.regular", nil), NSLocalizedString(@"payment.method.card", nil)]];
        [self.view addSubview:selectionView];

        CGFloat selectionHeight = CGRectGetHeight(selectionView.frame);

        NSArray *movedControllers = @[self.cardViewController, self.bankViewController];
        for (UIViewController *controller in movedControllers) {
            CGRect frame = controller.view.frame;
            frame.origin.y += selectionHeight;
            frame.size.height -= selectionHeight;
            [controller.view setFrame:frame];
        }
    }
}

- (void)selectionChangedToIndex:(NSInteger)index {
    if (index == 0) {
        [self.view bringSubviewToFront:self.bankViewController.view];
    } else {
		[[GoogleAnalytics sharedInstance] sendScreen:@"Debit card payment"];
        [self.cardViewController loadCardView];
        [self.view bringSubviewToFront:self.cardViewController.view];
    }
}

- (void)attachChildController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [controller.view setFrame:self.view.bounds];
    [self.view addSubview:controller.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
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

        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
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

@end
