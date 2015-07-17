//
//  PaymentMethodSelectorViewController.m
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayHelper.h"
#import "ApplePayFlow.h"
#import "Currency.h"
#import "GoogleAnalytics.h"
#import "MOMStyle.h"
#import "Mixpanel+Customisation.h"
#import "PayInMethod.h"
#import "Payment.h"
#import "PaymentMethodCell.h"
#import "PaymentMethodSelectorViewController.h"
#import "TransferBackButtonItem.h"
#import "UploadMoneyViewController.h"
#import "ApplePayCell.h"
@import PassKit;

#define PaymentMethodCellName @"PaymentMethodCell"
#define ApplePayCellName @"ApplePayCell"

#define APPLE_PAY @"APPLE_PAY"

@interface PaymentMethodSelectorViewController () <UITableViewDataSource, PaymentMethodCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSArray* sortedPayInMethods;
@property (strong, nonatomic) ApplePayFlow *applePayFlow;

@end

@implementation PaymentMethodSelectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:PaymentMethodCellName
											   bundle:[NSBundle mainBundle]]
		 forCellReuseIdentifier:PaymentMethodCellName];
	[self.tableview registerNib:[UINib nibWithNibName:ApplePayCellName
											   bundle:[NSBundle mainBundle]]
		 forCellReuseIdentifier:ApplePayCellName];
	
    [self setTitle:NSLocalizedString(@"upload.money.title.single.method",nil)];	
	
	NSMutableArray *sortedPayInMethodTypes = [[self.payment sortedPayInMethodTypes] mutableCopy];
	
	if ([ApplePayHelper isApplePayAvailableForPayment: self.payment])
	{
		//Apple Pay is in play
		[sortedPayInMethodTypes addObject:APPLE_PAY];
		self.applePayFlow = [ApplePayFlow sharedInstanceWithPayment:self.payment
														objectModel:self.objectModel
													 successHandler:^{
														 
													 }
											  hostingViewController:self];
	}
	
	self.sortedPayInMethods = sortedPayInMethodTypes;
	
    [[GoogleAnalytics sharedInstance] sendScreen:GAPaymentMethodSelector];
    [[Mixpanel sharedInstance] sendPageView:MPPaymentMethodSelector];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    __weak typeof(self) weakSelf = self;
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        if(weakSelf.presentingViewController)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }]];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return self.sortedPayInMethods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *payInMethod = self.sortedPayInMethods[indexPath.row];
	PaymentMethodCell *cell;
	
	if ([APPLE_PAY caseInsensitiveCompare:payInMethod] == NSOrderedSame)
	{
		cell = (ApplePayCell *)[tableView dequeueReusableCellWithIdentifier:ApplePayCellName];
	}
	else
	{
		cell = (PaymentMethodCell*) [tableView dequeueReusableCellWithIdentifier:PaymentMethodCellName];
	}
	
	[cell configureWithPaymentMethod:payInMethod
						fromCurrency:[self.payment sourceCurrency].code];
	
	[self setCellBackground:indexPath
					   cell:cell];
	cell.paymentMethodCellDelegate = self;
	
	return cell;
}

- (void)setCellBackground:(NSIndexPath *)indexPath
					 cell:(UITableViewCell *)cell
{
	MOMBasicStyle * style = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"LightBlue"];
	cell.contentView.backgroundColor = [UIColor colorWithRed:[style.red floatValue]
													   green:[style.green floatValue]
														blue:[style.blue floatValue]
													   alpha:(indexPath.row%3)/2.0f];
}

-(void)actionButtonTappedOnCell:(PaymentMethodCell *)cell
					 withMethod:(NSString *)method
{
	if ([APPLE_PAY caseInsensitiveCompare:method] == NSOrderedSame)
	{
		//Apple Pay is the sore thumb here
		[self.applePayFlow handleApplePay];
	}
	else
	{
		UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
		controller.objectModel = self.objectModel;
		controller.forcedMethod = method;
		controller.payment = self.payment;
		[self.navigationController pushViewController:controller animated:YES];
		__weak typeof(self) weakSelf = self;
		[controller.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}]];
	}
}

@end
