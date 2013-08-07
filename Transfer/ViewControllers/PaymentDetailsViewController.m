//
//  PaymentDetailsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 8/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentDetailsViewController.h"
#import "Payment.h"

@interface PaymentDetailsViewController ()

@end

@implementation PaymentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:self.payment.localizedStatus];
}

@end
