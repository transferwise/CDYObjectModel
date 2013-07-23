//
//  IntroductionViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionViewController.h"
#import "TableHeaderView.h"
#import "MoneyEntryCell.h"
#import "LoginViewController.h"
#import "UIColor+Theme.h"
#import "UIView+Loading.h"
#import "MoneyCalculator.h"
#import "CalculationResult.h"
#import "CurrencyPairsOperation.h"
#import "SWRevealViewController.h"
#import "WhyView.h"
#import "TSAlertView.h"
#import "PlainCurrency.h"
#import "MoneyFormatter.h"
#import "TRWAlertView.h"
#import "PaymentFlow.h"
#import "NoUserPaymentFlow.h"
#import "Credentials.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+CurrencyPairs.h"
#import "Currency.h"
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
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyEntryCell" bundle:nil] forCellReuseIdentifier:TWMoneyEntryCellIdentifier];

    self.whyView = [[WhyView alloc] init];

    [self setYouSendCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
    [self.youSendCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.youSendCell setRoundedCorner:UIRectCornerTopRight];

    [self setTheyReceiveCell:[self.tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier]];
    [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
    [self.theyReceiveCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:@(1000)] currency:nil];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.theyReceiveCell setRoundedCorner:UIRectCornerBottomRight];
    [self.theyReceiveCell setEditable:NO];

    TableHeaderView *header = [TableHeaderView loadInstance];
    [header setMessage:NSLocalizedString(@"introduction.header.title.text", nil)];
    [self.tableView setTableHeaderView:header];
    [self.tableView setTableFooterView:self.controlsView];

    [self.savingsLabel setText:@""];
    [self.savingsLabel setTextColor:[UIColor mainTextColor]];
    [self.loginTitle setText:NSLocalizedString(@"introduction.login.section.title", nil)];
    [self.loginTitle setTextColor:[UIColor mainTextColor]];

    [self.startedButton setTitle:NSLocalizedString(@"button.title.get.started", nil) forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];

    MoneyCalculator *calculator = [[MoneyCalculator alloc] init];
    [self setCalculator:calculator];

    [calculator setSendCell:self.youSendCell];
    [calculator setReceiveCell:self.theyReceiveCell];

    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButtonIcon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button.title.back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    [backButton setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = backButton;
    
    [[OHAttributedLabel appearance] setLinkUnderlineStyle:kOHBoldStyleTraitSetBold];
    [[OHAttributedLabel appearance] setLinkColor:[UIColor colorWithRed:50.0/255.0 green:58.0/255.0 blue:69.0/255.0 alpha:1]];

    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        if (error) {
            MCLog(@"Calculation error:%@", error);
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
    [self.calculator forceCalculate];

    [self retrieveCurrencyPairs];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([Credentials temporaryAccount]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)retrieveCurrencyPairs {
    if (self.dummyPresentation) {
        //It is dummy instance used on app launch
        return;
    }

    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCurrenciesHandler:^(NSError *error) {
        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"introduction.currencies.retrieve.error.title", nil)
                                                               message:NSLocalizedString(@"introduction.currencies.retrieve.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.retry", nil) action:^{
                [self retrieveCurrencyPairs];
            }];
            [alertView show];
            return;
        }

        [self.calculator forceCalculate];
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

    PaymentFlow *paymentFlow = [[NoUserPaymentFlow alloc] initWithPresentingController:self.navigationController];
    [self setPaymentFlow:paymentFlow];

    [paymentFlow setObjectModel:self.objectModel];
    [paymentFlow setCalculationResult:self.result];

    [paymentFlow presentSenderDetails];
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


@end
