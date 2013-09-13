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

@interface UploadMoneyViewController ()

@property (nonatomic, strong) BankTransferViewController *bankViewController;

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

    BankTransferViewController *controller = [[BankTransferViewController alloc] init];
    [self setBankViewController:controller];
    [self addChildViewController:controller];

    [controller.view setFrame:self.view.bounds];
    [self.view addSubview:controller.view];

    [controller setPayment:self.payment];
    [controller setObjectModel:self.objectModel];
    [controller setHideBottomButton:self.hideBottomButton];
    [controller setShowContactSupportCell:self.showContactSupportCell];
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
