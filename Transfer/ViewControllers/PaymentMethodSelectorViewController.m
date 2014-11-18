//
//  PaymentMethodSelectorViewController.m
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodSelectorViewController.h"
#import "Payment.h"
#import "PaymentMethodCell.h"
#import "MOMStyle.h"
#import "PaymentMethodViewControllerFactory.h"
#import "TransferBackButtonItem.h"
#import "Currency.h"
#import "PayInMethod.h"

#define PaymentMethodCellName @"PaymentMethodCell"

@interface PaymentMethodSelectorViewController () <UITableViewDataSource, PaymentMethodCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray* sortedPayInMethods;

@end

@implementation PaymentMethodSelectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:PaymentMethodCellName bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:nib forCellReuseIdentifier:PaymentMethodCellName];
    [self setTitle:NSLocalizedString(@"upload.money.title.single.method",nil)];
	self.sortedPayInMethods = [[self.payment enabledPayInMethods] sortedArrayUsingComparator:^NSComparisonResult(PayInMethod *method1, PayInMethod *method2) {
			return (NSInteger)[[PayInMethod supportedPayInMethods] objectForKeyedSubscript:method1.type] > (NSInteger)[[PayInMethod supportedPayInMethods] objectForKey:method2.type];
	}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
    }]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.payment enabledPayInMethods] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentMethodCell *cell = (PaymentMethodCell*) [tableView dequeueReusableCellWithIdentifier:PaymentMethodCellName];
    [cell configureWithPaymentMethod:self.sortedPayInMethods[indexPath.row]
						fromCurrency:[self.payment sourceCurrency].code];
    MOMBasicStyle * style = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"LightBlue"];
    cell.contentView.backgroundColor = [UIColor colorWithRed:[style.red floatValue] green:[style.green floatValue] blue:[style.blue floatValue] alpha:(indexPath.row%3)/2.0f];
    cell.paymentMethodCellDelegate = self;
    return cell;
}

-(void)actionButtonTappedOnCell:(PaymentMethodCell *)cell withMethod:(PayInMethod *)method
{
    UIViewController *controller = [PaymentMethodViewControllerFactory viewControllerForPayInMethod:method forPayment:self.payment objectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
    __weak typeof(self) weakSelf = self;
    [controller.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
      [weakSelf.navigationController popViewControllerAnimated:YES];
    }]];

}


@end
