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
#import "Constants.h"
#import "CalculationResult.h"
#import "Currency.h"
#import "TransferwiseClient.h"
#import "TRWProgressHUD.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

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
    [self.youSendCell setAmount:@"1000.00" currency:[Currency currencyWithCode:@"GBP"]];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:@"" currency:[Currency currencyWithCode:@"EUR"]];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

    [calculator setSendCell:self.youSendCell];
    [calculator setReceiveCell:self.theyReceiveCell];
    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        MCLog(@"Calculation result:%@", result);
        MCLog(@"Calculation error:%@", error);

        [self showPaymentReceivedOnDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24]];
        [self fillDepositFieldsWithResult:result];

        [self.tableView setTableFooterView:self.footerView];
    }];

    [self.continueToDetailsButton setTitle:NSLocalizedString(@"payment.controller.continue.to.details.button.title", nil) forState:UIControlStateNormal];

    [self.depositTitleLabel setText:NSLocalizedString(@"payment.controller.deposit.label", nil)];
    [self.transferFeeTitleLabel setText:NSLocalizedString(@"payment.controller.transfer.fee.label", nil)];
    [self.transferFeeTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.currencyCostTitleLabel setText:NSLocalizedString(@"payment.controller.currency.cost.label", nil)];
    [self.currencyCostTitleLabel setTextColor:[UIColor mainTextColor]];
    [self.exchangeRateTitleLabel setText:NSLocalizedString(@"payment.controller.estimated.exchange.rate.label", nil)];
    [self.youGetTitleLabel setText:NSLocalizedString(@"payment.controller.you.get.label", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBarController.navigationItem setRightBarButtonItem:nil];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"introduction.refreshing.currencies.message", nil)];

    [[TransferwiseClient sharedClient] updateCurrencyPairsWithCompletionHandler:^(NSArray *currencies, NSError *error) {
        [hud hide];
        [self.calculator setCurrencies:currencies];
        [self.calculator forceCalculate];
    }];
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

- (void)showPaymentReceivedOnDate:(NSDate *)date {
    NSString *dateString = [[PaymentViewController paymentDateFormatter] stringFromDate:date];
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
    [self.currencyCostValueLabel setText:[result transferwisePayOutStringWithCurrency]];
    [self.exchangeRateValueLabel setText:[result transferwiseRateString]];
    [self.youGetValueLabel setText:[result transferwisePayOutStringWithCurrency]];
}

NSDateFormatter *__paymentDateFormatter;
+ (NSDateFormatter *)paymentDateFormatter {
    if (!__paymentDateFormatter) {
        __paymentDateFormatter = [[NSDateFormatter alloc] init];
        [__paymentDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [__paymentDateFormatter setDateStyle:NSDateFormatterFullStyle];
    }

    return __paymentDateFormatter;
}

@end
