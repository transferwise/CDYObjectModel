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
#import "PlainRecipient.h"
#import "CalculationResult.h"
#import "PlainCurrency.h"
#import "ObjectModel.h"
#import "TransferwiseClient.h"
#import "TRWAlertView.h"
#import "PaymentFlow.h"
#import "MoneyFormatter.h"
#import "LoggedInPaymentFlow.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "UITableView+FooterPositioning.h"
#import "ObjectModel+Currencies.h"
#import "ObjectModel+CurrencyPairs.h"
#import "Currency.h"

static NSUInteger const kRowYouSend = 0;

@interface PaymentViewController ()

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

    [self setYouSendCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
    [self.youSendCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.youSendCell setRoundedCorner:UIRectCornerTopRight];

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.theyReceiveCell setForcedCurrency:self.recipient ? [self.objectModel currencyWithCode:self.recipient.currency] : nil];
    [self.theyReceiveCell setRoundedCorner:UIRectCornerBottomRight];
    [self.theyReceiveCell setEditable:NO];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

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

        [self showPaymentReceivedOnDate:result.paymentDateString];
        [self fillDepositFieldsWithResult:result];

        [self.tableView setTableFooterView:self.footerView];
        [self.tableView adjustFooterViewSize];
        
    }];

    [self.continueToDetailsButton setTitle:NSLocalizedString(@"payment.controller.continue.to.details.button.title", nil) forState:UIControlStateNormal];

    [self.depositTitleLabel setText:NSLocalizedString(@"payment.controller.deposit.label", nil)];
    [self.transferFeeTitleLabel setText:NSLocalizedString(@"payment.controller.transfer.fee.label", nil)];
    [self.transferFeeTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.transferFeeValueLabel setTextColor:[UIColor mainTextColor]];
    [self.currencyCostTitleLabel setText:NSLocalizedString(@"payment.controller.currency.cost.label", nil)];
    [self.currencyCostTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.currencyCostValueLabel setTextColor:[UIColor mainTextColor]];
    [self.exchangeRateTitleLabel setText:NSLocalizedString(@"payment.controller.estimated.exchange.rate.label", nil)];
    [self.youGetTitleLabel setText:NSLocalizedString(@"payment.controller.you.get.label", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBarController.navigationItem setRightBarButtonItem:nil];

    [self.navigationItem setTitle:NSLocalizedString(@"payment.controller.title", nil)];

    [self.calculator setObjectModel:self.objectModel];

    if (self.recipient) {
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSourcesContainingTargetCurrency:[self.objectModel currencyWithCode:self.recipient.currency]]];
    } else {
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
    }

    [self.calculator forceCalculate];


    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCurrenciesHandler:^(NSError *error) {
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"payment.controller.calculation.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [self.calculator forceCalculate];

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

    PaymentFlow *paymentFlow = [[LoggedInPaymentFlow alloc] initWithPresentingController:self.navigationController];
    [self setPaymentFlow:paymentFlow];

    [paymentFlow setObjectModel:self.objectModel];
    [paymentFlow setSourceCurrency:[[self.youSendCell currency] plainCurrency]];
    [paymentFlow setTargetCurrency:[[self.theyReceiveCell currency] plainCurrency]];
    [paymentFlow setCalculationResult:self.calculationResult];
    [paymentFlow setRecipient:self.recipient];

    [paymentFlow presentSenderDetails];
}

@end
