//
//  PaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentViewController.h"
#import "MoneyEntryCell.h"
#import "UIColor+Theme.h"
#import "MoneyCalculator.h"
#import "CalculationResult.h"
#import "Recipient.h"
#import "ObjectModel.h"
#import "TransferwiseClient.h"
#import "TRWAlertView.h"
#import "PaymentFlow.h"
#import "MoneyFormatter.h"
#import "LoggedInPaymentFlow.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "UITableView+FooterPositioning.h"
#import "ObjectModel+CurrencyPairs.h"
#import "Currency.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "PairTargetCurrency.h"
#import "PairSourceCurrency.h"
#import "TabBarActivityIndicatorView.h"
#import "UIView+Loading.h"
#import "SwitchCell.h"
#import "TransferBackButtonItem.h"
#import "GoogleAnalytics.h"

static NSUInteger const kRowYouSend = 0;

@interface PaymentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MoneyEntryCell *youSendCell;
@property (nonatomic, strong) MoneyEntryCell *theyReceiveCell;
@property (nonatomic, strong) MoneyCalculator *calculator;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *paymentReceiveDateLabel;
@property (nonatomic, strong) IBOutlet UIButton *continueToDetailsButton;
@property (nonatomic, strong) IBOutlet UILabel *depositTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *transferFeeTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyCostTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *depositValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *transferFeeValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyCostValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *exchangeRateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *exchangeRateValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *youGetTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *youGetValueLabel;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, strong) PaymentFlow *paymentFlow;
@property (nonatomic, strong) CurrencyPairsOperation *executedOperation;
@property (nonatomic, strong) TabBarActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)continuePressed:(id)sender;

@end

@implementation PaymentViewController

- (id)init {
    self = [super initWithNibName:@"PaymentViewController" bundle:nil];
    if (self) {
        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"payment.controller.title", nil)
                                                              image:[UIImage imageNamed:@"NewPaymentTabIcon.png"] tag:0];
        [self setTabBarItem:barItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyEntryCell" bundle:nil] forCellReuseIdentifier:TWMoneyEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:TWSwitchCellIdentifier];

    [self setYouSendCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];

    [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
    [self.youSendCell setAmount:@"1000" currency:nil];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];
    if (!IOS_7) {
        [self.youSendCell setRoundedCorner:UIRectCornerTopRight];
    }
    [self.youSendCell setEditable:YES];

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.theyReceiveCell setForcedCurrency:self.recipient ? self.recipient.currency : nil];
    if (!IOS_7) {
        [self.theyReceiveCell setRoundedCorner:UIRectCornerBottomRight];
    }
    [self.theyReceiveCell setEditable:NO];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

    [calculator setActivityHandler:^(BOOL calculating) {
        [self presentActivityIndicator:calculating];
    }];

    [calculator setSendCell:self.youSendCell];
    [calculator setReceiveCell:self.theyReceiveCell];
    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        MCLog(@"Calculation result:%@", result);
        MCLog(@"Calculation error:%@", error);

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"payment.controller.calculation.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [self setCalculationResult:result];

        [self showPaymentReceivedOnDate:result.formattedEstimatedDelivery];
        [self fillDepositFieldsWithResult:result];

        [self.tableView setTableFooterView:self.footerView];
        [self.tableView adjustFooterViewSize];

    }];

    [self.depositTitleLabel setText:NSLocalizedString(@"payment.controller.deposit.label", nil)];
    [self.transferFeeTitleLabel setText:NSLocalizedString(@"payment.controller.transfer.fee.label", nil)];
    [self.transferFeeTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.transferFeeValueLabel setTextColor:[UIColor mainTextColor]];
    [self.currencyCostTitleLabel setText:NSLocalizedString(@"payment.controller.currency.cost.label", nil)];
    [self.currencyCostTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.currencyCostValueLabel setTextColor:[UIColor mainTextColor]];
    [self.exchangeRateTitleLabel setText:NSLocalizedString(@"payment.controller.estimated.exchange.rate.label", nil)];
    [self.youGetTitleLabel setText:NSLocalizedString(@"payment.controller.you.get.label", nil)];

    if (IOS_7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];

    [self.tabBarController.navigationItem setRightBarButtonItem:nil];

    if (!self.tabBarController) {
        [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
            [self.navigationController popViewControllerAnimated:YES];
        }]];
    }

    if (self.recipient) {
        NSRange range = [self.recipient.name rangeOfString:@" "];
        NSString *formattedName = self.recipient.name;
        if (range.location != NSNotFound) {
            formattedName = [[self.recipient.name substringToIndex:range.location + 2] stringByAppendingString:@"."];
        }
        [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"payment.controller.title.with.contact.name", nil), formattedName]];
        [self.continueToDetailsButton setTitle:NSLocalizedString(@"button.title.continue", nil) forState:UIControlStateNormal];
    } else {
        [self.navigationItem setTitle:NSLocalizedString(@"payment.controller.title", nil)];
        [self.continueToDetailsButton setTitle:NSLocalizedString(@"payment.controller.continue.to.details.button.title", nil) forState:UIControlStateNormal];
    }
    [self.calculator setObjectModel:self.objectModel];

    if (self.youSendCell.currencies) {
        [self.calculator forceCalculate];
        [self refreshCurrencyPairs];
        return;
    }

    if (self.recipient) {
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSourcesContainingTargetCurrency:self.recipient.currency]];
    } else {
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
    }

    [self.calculator forceCalculate];
    [self refreshCurrencyPairs];
}

- (void)refreshCurrencyPairs {
    if (self.executedOperation) {
        return;
    }

    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCurrenciesHandler:^(NSError *error) {
        [self setExecutedOperation:nil];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"payment.controller.calculation.error.title", nil) error:error];
            [alertView show];
            return;
        }
    }];

    [operation execute];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == kRowYouSend) {
        return self.youSendCell;
    }
    return self.theyReceiveCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)showPaymentReceivedOnDate:(NSString *)paymentDateString {
    NSString *dateString = paymentDateString;
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"payment.controller.payment.date.message", nil), dateString];
    NSRange dateRange = [messageString rangeOfString:dateString];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:messageString];

    OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.textAlignment = kCTTextAlignmentCenter;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [attributedString setParagraphStyle:paragraphStyle];
    [attributedString setFont:[UIFont systemFontOfSize:13]];
    [attributedString setFont:[UIFont boldSystemFontOfSize:13] range:dateRange];
    [attributedString setTextColor:[UIColor mainTextColor]];

    [self.paymentReceiveDateLabel setAttributedText:attributedString];
}

- (void)fillDepositFieldsWithResult:(CalculationResult *)result {
    [self.depositValueLabel setText:[result transferwisePayInStringWithCurrency]];
    [self.transferFeeValueLabel setText:[result transferwiseTransferFeeStringWithCurrency]];
    [self.currencyCostValueLabel setText:[result transferwiseCurrencyCostStringWithCurrency]];
    [self.exchangeRateValueLabel setText:[result transferwiseRateString]];
    [self.youGetValueLabel setText:[result transferwisePayOutStringWithCurrency]];
}

- (IBAction)continuePressed:(id)sender {
    if (!self.calculationResult) {
        return;
    }

	[[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];

    //TODO jaanus: copy/paste
    Currency *sourceCurrency = [self.youSendCell currency];
    Currency *targetCurrency = [self.theyReceiveCell currency];
    NSNumber *payIn = [self.calculationResult transferwisePayIn];

    PairTargetCurrency *target = [self.objectModel pairWithSource:sourceCurrency target:targetCurrency];
    if (![target acceptablePayIn:payIn]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.low.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.low.message.base", nil), target.minInvoiceAmount, target.source.currency.code]];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel createPendingPayment];
        [payment setSourceCurrency:sourceCurrency];
        [payment setTargetCurrency:targetCurrency];
        [payment setRecipient:self.recipient];
        [payment setPayIn:(NSDecimalNumber *) payIn];
        [payment setPayOut:(NSDecimalNumber *) [self.calculationResult transferwisePayOut]];
        [payment setConversionRate:[self.calculationResult transferwiseRate]];
        [payment setEstimatedDelivery:[self.calculationResult estimatedDelivery]];
        [payment setEstimatedDeliveryStringFromServer:[self.calculationResult formattedEstimatedDelivery]];
		[payment setTransferwiseTransferFee:[self.calculationResult transferwiseTransferFee]];

        PaymentFlow *paymentFlow = [[LoggedInPaymentFlow alloc] initWithPresentingController:self.navigationController];
        [self setPaymentFlow:paymentFlow];

        [paymentFlow setObjectModel:self.objectModel];

        [self.objectModel performBlock:^{
            [paymentFlow presentFirstPaymentScreen];
        }];
    }];
}

- (void)presentActivityIndicator:(BOOL)calculating {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!calculating) {
            [self.activityIndicator removeFromSuperview];
            [self setActivityIndicator:nil];
            return;
        }

        if (self.tabBarController) {
            TabBarActivityIndicatorView *indicatorView = [TabBarActivityIndicatorView showHUDOnController:self];
            [self setActivityIndicator:indicatorView];
            [indicatorView setMessage:NSLocalizedString(@"calculation.pending.message", nil)];
        } else {
            TabBarActivityIndicatorView *indicatorView = [TabBarActivityIndicatorView loadInstance];
            [self setActivityIndicator:indicatorView];
            [self.view addSubview:indicatorView];
            [indicatorView setMessage:NSLocalizedString(@"calculation.pending.message", nil)];
            CGRect indicatorFrame = indicatorView.frame;
            indicatorFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(indicatorFrame);
            [indicatorView setFrame:indicatorFrame];

        }
    });
}

@end
