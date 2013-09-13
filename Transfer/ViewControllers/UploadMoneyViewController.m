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

@interface UploadMoneyViewController ()

@property (nonatomic, strong) BankTransferViewController *bankViewController;
@property (nonatomic, strong) CardPaymentViewController *cardViewController;

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

    [self.navigationController flattenStack];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
