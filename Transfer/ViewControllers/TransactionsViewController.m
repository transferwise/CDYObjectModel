//
//  TransactionsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransactionsViewController.h"
#import "PaymentsOperation.h"
#import "UIColor+Theme.h"
#import "PaymentCell.h"
#import "TRWProgressHUD.h"
#import "Payment.h"

NSString *const kPaymentCellIdentifier = @"kPaymentCellIdentifier";

@interface TransactionsViewController ()

@property (nonatomic, strong) PaymentsOperation *executedOperation;
@property (nonatomic, strong) NSArray *payments;

@end

@implementation TransactionsViewController

- (id)init {
    self = [super initWithNibName:@"TransactionsViewController" bundle:nil];
    if (self) {
        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"transactions.controller.title", nil) image:[UIImage imageNamed:@"TransactionsTabIcon.png"] tag:0];
        [self setTabBarItem:barItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:kPaymentCellIdentifier];

    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self refreshPaymentsList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.payments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellIdentifier];

    Payment *payment = [self.payments objectAtIndex:(NSUInteger) indexPath.row];
    [cell configureWithPayment:payment];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshPaymentsList {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"transactions.controller.refreshing.message", nil)];

    PaymentsOperation *operation = [[PaymentsOperation alloc] init];
    [self setExecutedOperation:operation];

    [operation setCompletion:^(NSArray *payments, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            [self setPayments:payments];
            [self.tableView reloadData];
        });
    }];

    [operation execute];
}

@end
