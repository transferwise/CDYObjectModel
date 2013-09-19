//
//  IntroductionViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionViewController.h"
#import "MoneyEntryCell.h"
#import "LoginViewController.h"
#import "MoneyCalculator.h"
#import "CalculationResult.h"
#import "CurrencyPairsOperation.h"
#import "WhyView.h"
#import "TSAlertView.h"
#import "MoneyFormatter.h"
#import "TabBarActivityIndicatorView.h"
#import "TRWAlertView.h"
#import "PaymentFlow.h"
#import "NoUserPaymentFlow.h"
#import "Credentials.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+CurrencyPairs.h"
#import "Currency.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "PairTargetCurrency.h"
#import "PairSourceCurrency.h"
#import "UITableView+FooterPositioning.h"
#import "GoogleAnalytics.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

static NSUInteger const kRowYouSend = 0;

@interface IntroductionViewController () <UITextFieldDelegate, OHAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIView *controlsView;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *savingsLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginTitle;
@property (nonatomic, strong) IBOutlet UIButton *startedButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) MoneyEntryCell *youSendCell;
@property (nonatomic, strong) MoneyEntryCell *theyReceiveCell;
@property (nonatomic, strong) MoneyCalculator *calculator;
@property (nonatomic, strong) CalculationResult *result;
@property (nonatomic, strong) WhyView *whyView;
@property (nonatomic, strong) PaymentFlow *paymentFlow;
@property (nonatomic, strong) CurrencyPairsOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) TabBarActivityIndicatorView *activityIndicator;

- (IBAction)loginPressed:(id)sender;
- (IBAction)startPaymentPressed:(id)sender;

@end

@implementation IntroductionViewController

- (id)init {
    self = [super initWithNibName:@"IntroductionViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LandingBackground.png"]]];

    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyEntryCell" bundle:nil] forCellReuseIdentifier:TWMoneyEntryCellIdentifier];

    self.whyView = [[WhyView alloc] init];

    [self setYouSendCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
    [self.youSendCell setAmount:@"1000" currency:nil];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];
    if (!IOS_7) {
        [self.youSendCell setRoundedCorner:UIRectCornerTopRight];
    }

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];
    if (!IOS_7) {
        [self.theyReceiveCell setRoundedCorner:UIRectCornerBottomRight];
    }
    [self.theyReceiveCell setEditable:NO];

    [self.titleLabel setText:NSLocalizedString(@"introduction.header.title.text", nil)];

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.controlsView];

    [self.savingsLabel setText:@""];
    [self.loginTitle setText:NSLocalizedString(@"introduction.login.section.title", nil)];

    [self.startedButton setTitle:NSLocalizedString(@"button.title.get.started", nil) forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

    [calculator setSendCell:self.youSendCell];
    [calculator setReceiveCell:self.theyReceiveCell];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button.title.back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    [backButton setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = backButton;
    
    [[OHAttributedLabel appearance] setLinkColor:[UIColor whiteColor]];

    [calculator setActivityHandler:^(BOOL calculating) {
        [self showCalculationIndicator:calculating];
    }];

    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"introduction.calculation.error.title", nil) error:error];
            [alertView show];
            return;
        }

        self.result = result;
        NSString *winMessage = [self winMessage:result];
        NSString *txt = [NSMutableString stringWithFormat:@"%@. %@", winMessage, NSLocalizedString(@"introduction.savings.message.why", nil)];
        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:txt];

        OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
        paragraphStyle.textAlignment = kCTTextAlignmentCenter;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        [attrStr setParagraphStyle:paragraphStyle];
        [attrStr setFont:self.savingsLabel.font];
        [attrStr setTextColor:self.savingsLabel.textColor];

        NSString *linkURLString = @"why:"; // build the "why" link
        [attrStr setLink:[NSURL URLWithString:linkURLString] range:[txt rangeOfString:NSLocalizedString(@"introduction.savings.message.why", nil)]];
        self.savingsLabel.attributedText = attrStr;
    }];
}

- (NSString *)winMessage:(CalculationResult *)result {
    NSString *winMessage;
    if (result.amountCurrency == SourceCurrency) {
        winMessage = [NSString stringWithFormat:NSLocalizedString(@"introduction.savings.receive.message.base", nil), [result receiveWinAmountWithCurrency]];
    } else {
        winMessage = [NSString stringWithFormat:NSLocalizedString(@"introduction.savings.pay.message.base", nil), [result payWinAmountWithCurrency]];
    }
    return winMessage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TWlogo.png"]];
    [self.navigationItem setTitleView:logoView];

    MCAssert(self.objectModel);

    [self.calculator setObjectModel:self.objectModel];
    [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
    if (!self.dummyPresentation) {
        [self.calculator forceCalculate];
    }

    [self retrieveCurrencyPairs];

    [self.tableView adjustFooterViewSize:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([Credentials temporaryAccount]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

	if (!self.dummyPresentation) {
		[[GoogleAnalytics sharedInstance] sendScreen:@"Start screen"];
	}
}

- (void)retrieveCurrencyPairs {
    if (self.dummyPresentation) {
        //It is dummy instance used on app launch
        return;
    }

    if (self.executedOperation) {
        return;
    }

    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCurrenciesHandler:^(NSError *error) {
        [self setExecutedOperation:nil];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"introduction.currencies.retrieve.error.title", nil)
                                                               message:NSLocalizedString(@"introduction.currencies.retrieve.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.retry", nil) action:^{
                [self retrieveCurrencyPairs];
            }];
            [alertView show];
            return;
        }
    }];

    [operation setObjectModel:self.objectModel];
    [operation execute];
}

#pragma mark - Table view data source

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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == kRowYouSend) {
        [self.youSendCell.moneyField becomeFirstResponder];
    } else {
        [self.theyReceiveCell.moneyField becomeFirstResponder];
    }
}

- (IBAction)loginPressed:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)startPaymentPressed:(id)sender {
    if (!self.result) {
        return;
    }

    //TODO jaanus: copy/paste
	[[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];

	Currency *sourceCurrency = [self.youSendCell currency];
    Currency *targetCurrency = [self.theyReceiveCell currency];
    NSNumber *payIn = [self.result transferwisePayIn];

    PairTargetCurrency *target = [self.objectModel pairWithSource:sourceCurrency target:targetCurrency];
    if (![target acceptablePayIn:payIn]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.low.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.low.message.base", nil), target.minInvoiceAmount, target.source.currency.code]];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel createPendingPayment];
        [payment setSourceCurrency:[self.youSendCell currency]];
        [payment setTargetCurrency:[self.theyReceiveCell currency]];
        [payment setPayIn:(NSDecimalNumber *) [self.result transferwisePayIn]];
        [payment setPayOut:(NSDecimalNumber *) [self.result transferwisePayOut]];
        [payment setConversionRate:[self.result transferwiseRate]];
        [payment setEstimatedDelivery:[self.result estimatedDelivery]];
        [payment setEstimatedDeliveryStringFromServer:[self.result formattedEstimatedDelivery]];
		[payment setTransferwiseTransferFee:[self.result transferwiseTransferFee]];

		PaymentFlow *paymentFlow = [[NoUserPaymentFlow alloc] initWithPresentingController:self.navigationController];
        [self setPaymentFlow:paymentFlow];

        [paymentFlow setObjectModel:self.objectModel];

        [self.objectModel performBlock:^{
            [paymentFlow presentFirstPaymentScreen];
        }];
    }];
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHAttributedString Delegate Method
/////////////////////////////////////////////////////////////////////////////


- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo {
    if ([[linkInfo.URL scheme] isEqualToString:@"why"]) {
        [self.whyView setupWithResult:self.result];
        [self.whyView setTitle:[self winMessage:self.result]];
        TSAlertView *alert = [[TSAlertView alloc] initWithTitle:self.whyView.title view:self.whyView delegate:nil cancelButtonTitle:NSLocalizedString(@"whypopup.button", nil) otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else {
        return NO;
    }
}

- (void)showCalculationIndicator:(BOOL)calculating {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!calculating) {
            [self.activityIndicator removeFromSuperview];
            [self setActivityIndicator:nil];
            return;
        }

        TabBarActivityIndicatorView *indicatorView = [TabBarActivityIndicatorView showHUDOnController:self];
        [self setActivityIndicator:indicatorView];
        [indicatorView setMessage:NSLocalizedString(@"calculation.pending.message", nil)];
    });
}

@end
