//
//  IntroductionViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NewPaymentViewController.h"
#import "MoneyEntryCell.h"
#import "LoginViewController.h"
#import "MoneyCalculator.h"
#import "CalculationResult.h"
#import "CurrencyPairsOperation.h"
#import "TSAlertView.h"
#import "MoneyFormatter.h"
#import "TRWAlertView.h"
#import "PaymentFlow.h"
#import "NoUserPaymentFlow.h"
#import "LoggedInPaymentFlow.h"
#import "Credentials.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+CurrencyPairs.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+Payments.h"
#import "Currency.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "PairTargetCurrency.h"
#import "PairSourceCurrency.h"
#import "UITableView+FooterPositioning.h"
#import "GoogleAnalytics.h"
#import "CXAlertView.h"
#import "StartPaymentButton.h"
#import "MOMStyle.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "SeeHowViewController.h"
#import "SeeHowView.h"
#import "Recipient.h"
#import "User.h"
#import "RecipientTypesOperation.h"
#import "TRWProgressHUD.h"
#import "CustomInfoViewController.h"
#import "NavigationBarCustomiser.h"
#import "NewPaymentHelper.h"
#import "LocationHelper.h"
#import "Mixpanel+Customisation.h"



#define	PERSONAL_PROFILE	@"personal"
#define BUSINESS_PROFILE	@"business"

static NSUInteger const kRowYouSend = 0;

@interface NewPaymentViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (nonatomic, strong) IBOutlet StartPaymentButton *startedButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) MoneyEntryCell *youSendCell;
@property (nonatomic, strong) MoneyEntryCell *theyReceiveCell;
@property (nonatomic, strong) MoneyCalculator *calculator;
@property (nonatomic, strong) CalculationResult *result;
@property (nonatomic, strong) PaymentFlow *paymentFlow;
@property (nonatomic, strong) CurrencyPairsOperation *executedOperation;
@property (nonatomic, strong) NewPaymentHelper* paymentHelper;

@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *howButton;
@property (weak, nonatomic) UITapGestureRecognizer *dismissRecogniser;
@property (weak, nonatomic) IBOutlet UIButton *modalCloseButton;


@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *termsLabel;

- (IBAction)loginPressed:(id)sender;
- (IBAction)startPaymentPressed:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *howButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *termsBottomConstraint;

@end

@implementation NewPaymentViewController

- (id)init {
    self = [super initWithNibName:@"NewPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LandingBackground.png"]]];    

    Payment* latestPayment = [self.objectModel latestPayment];

    [self setYouSendCell:[[NSBundle mainBundle] loadNibNamed:@"MoneyEntryCell" owner:self options:nil][0]];
    [self.youSendCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:self.suggestedSourceAmount?:@(1000)] currency:nil];
    [self.youSendCell.moneyField setReturnKeyType:UIReturnKeyDone];
    self.youSendCell.hostForCurrencySelector = self;
    self.youSendCell.currencyButton.compoundStyle = @"sendButton";
    self.youSendCell.titleLabel.fontStyle = @"medium.@{15,17}.CoreFont";
	self.youSendCell.suggestedStartCurrency = self.suggestedSourceCurrency?:(latestPayment.sourceCurrency?:[LocationHelper getSourceCurrencyWithObjectModel:self.objectModel]);
    [self.youSendCell setEditable:YES];
	[self.youSendCell initializeSelectorBackground];

    [self setTheyReceiveCell:[[NSBundle mainBundle] loadNibNamed:@"MoneyEntryCell" owner:self options:nil][0]];
    [self.theyReceiveCell setAmount:[[MoneyFormatter sharedInstance] formatAmount:self.suggestedTargetAmount?:@(1000)] currency:nil];
    [self.theyReceiveCell.moneyField setReturnKeyType:UIReturnKeyDone];
    [self.theyReceiveCell setForcedCurrency:self.recipient ? self.recipient.currency : nil];
    self.theyReceiveCell.hostForCurrencySelector = self;
    self.theyReceiveCell.currencyButton.compoundStyle = @"getButton";
    self.theyReceiveCell.titleLabel.fontStyle = @"medium.@{15,17}.CoreFont";
    self.theyReceiveCell.contentView.bgStyle = @"LightBlueHighlighted";
	self.theyReceiveCell.leftSeparatorHidden = YES;
    self.theyReceiveCell.suggestedStartCurrency = self.suggestedTargetCurrency?:latestPayment.targetCurrency;
    [self.theyReceiveCell setEditable:YES];
	[self.theyReceiveCell initializeSelectorBackground];

    self.saveLabel.hidden=YES;
    self.howButton.hidden=YES;
    
	self.sendMoneyLabel.text = NSLocalizedString(@"introduction.title", nil);
    NSString *howString = NSLocalizedString([@"introduction.savings.message.how" deviceSpecificLocalization], nil);
    [self.howButton setTitle:howString forState:UIControlStateNormal];
    

    [self.startedButton setTitle:NSLocalizedString([(![Credentials userLoggedIn] ? @"button.title.get.started" : @"button.title.send.money") deviceSpecificLocalization], nil) forState:UIControlStateNormal];
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

    __weak NewPaymentViewController *weakSelf = self;
    [calculator setActivityHandler:^(BOOL calculating) {
        [weakSelf showCalculationIndicator:calculating];
    }];

    [calculator setCalculationHandler:^(CalculationResult *result, NSError *error) {
        if (error) {
            return;
        }

        weakSelf.result = result;
        [weakSelf displayWinMessage:result];
        
        [self updateApperanceAnimated:YES];
        
    }];
    
    MCAssert(self.objectModel);
    
    [self.calculator setObjectModel:self.objectModel];
    [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
    if (!self.dummyPresentation) {
        if(self.suggestedTransactionIsFixedTarget)
        {
            [self.calculator forceCalculateWithFixedTarget];
        }
        else
        {
            [self.calculator forceCalculate];
        }
        
    }
    
    [self retrieveCurrencyPairs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[GoogleAnalytics sharedInstance] sendScreen:GANewPayment];
    [[Mixpanel sharedInstance] sendPageView:MPNewTransfer];
    
	[self generateUsdLegaleze];
}

- (void)generateUsdLegaleze
{
	NSString* stateSpecific = NSLocalizedString(@"usd.state.specific", nil);
	NSString* legaleze = [NSString stringWithFormat:NSLocalizedString(@"usd.legaleze", nil),stateSpecific];
	NSMutableAttributedString *attributedLegaleze = [[NSMutableAttributedString alloc] initWithString:legaleze];
	NSRange wholeString = NSMakeRange(0, [legaleze length]);
	[attributedLegaleze addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:self.termsLabel.fontStyle] range:wholeString];
	[attributedLegaleze addAttribute:NSFontAttributeName value:[UIFont fontFromStyle:self.termsLabel.fontStyle] range:wholeString];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[attributedLegaleze addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:wholeString];
	NSRange stateRange = [legaleze rangeOfString:stateSpecific];
	[attributedLegaleze addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@%@",TRWServerAddress,TRWStateSpecificTermsUrl] range:stateRange];
	self.termsLabel.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorFromStyle:self.termsLabel.fontStyle], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	self.termsLabel.attributedText = attributedLegaleze;
	[self.termsLabel setTextContainerInset:UIEdgeInsetsZero];
}

-(void)keyboardWillShow:(NSNotification*)note
{
    UITapGestureRecognizer *dismissRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:dismissRecogniser];
    self.dismissRecogniser = dismissRecogniser;
}

-(void)keyboardDidHide:(NSNotification*)note
{
    [self.view removeGestureRecognizer:self.dismissRecogniser];
}

- (void)displayWinMessage:(CalculationResult *)result
{
    self.saveLabel.hidden = NO;
    self.howButton.hidden = NO;
    self.howButton.enabled = YES;
    
    NSString *savingsAmountString;
    if(result.amountCurrency == SourceCurrency)
    {
        savingsAmountString = [result calculatedPayWinAmountWithCurrency];
    }
    else
    {
        savingsAmountString = [result payWinAmountWithCurrency];
    }

    
    NSString *fullString;
    
    if(self.view.bounds.size.height > 480)
    {
        
        NSString *savings = [NSString stringWithFormat:NSLocalizedString(@"introduction.savings.message.part2.format", nil),savingsAmountString];
        NSString *rateAndFee;
        
        if([result isFeeZero] && self.view.bounds.size.height > 480)
        {
            rateAndFee = [NSString stringWithFormat:NSLocalizedString([@"introduction.savings.message.part1.format.no.fee" deviceSpecificLocalization], nil),result.transferwiseRateString];
        }
        else
        {
            rateAndFee = [NSString stringWithFormat:NSLocalizedString([@"introduction.savings.message.part1.format" deviceSpecificLocalization], nil),result.transferwiseRateString,result.transferwiseTransferFeeStringWithCurrency];
        }
        
        fullString = [NSString stringWithFormat:@"%@\n%@",rateAndFee, savings];
    }
    else
    {
        fullString = [NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"introduction.savings.message.iphone4.part1", nil),savingsAmountString, NSLocalizedString(@"introduction.savings.message.versus", nil)];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
    UIFont* normalFont = [UIFont fontFromStyle:@"book.@{20,27}"];
    UIFont* boldFont = [UIFont fontFromStyle:@"medium.@{20,27}"];
    
    UIColor *normalColor = [UIColor colorFromStyle:@"CoreFont"];
    UIColor *boldColor = [UIColor colorFromStyle:IPAD?@"DarkFont":@"TWBlueHighlighted"];
    
    NSRange fullRange = NSMakeRange(0,[fullString length]);
    NSRange boldRange = [fullString rangeOfString:savingsAmountString];
    
    [attributedString addAttribute:NSFontAttributeName value:normalFont range:fullRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:normalColor range:fullRange];
    if(boldRange.location != NSNotFound)
    {
        [attributedString addAttribute:NSFontAttributeName value:boldFont range:boldRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:boldColor range:boldRange];
    }
    
    self.saveLabel.attributedText = attributedString;
    [self.saveLabel layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TWlogo.png"]];
    [self.navigationItem setTitleView:logoView];
    
    if (self.recipient)
	{
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSourcesContainingTargetCurrency:self.recipient.currency]];
    }
	else
	{
        [self.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
    }
    
    self.loginButton.hidden = [Credentials userLoggedIn];
    self.modalCloseButton.hidden = ![Credentials userLoggedIn];
    self.logo.hidden = [Credentials userLoggedIn];
    [self updateApperanceAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([Credentials temporaryAccount])
	{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.view needsUpdateConstraints];
}

- (void)retrieveCurrencyPairs
{
    if (self.dummyPresentation)
	{
        //It is dummy instance used on app launch
        return;
    }

    if (self.executedOperation)
	{
        return;
    }

    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setCurrenciesHandler:^(NSError *error) {
        [self setExecutedOperation:nil];

        if (error)
		{
            return;
        }
        else
        {
            if (weakSelf.recipient) {
                [weakSelf.youSendCell setCurrencies:[self.objectModel fetchedControllerForSourcesContainingTargetCurrency:self.recipient.currency]];
            } else {
                [weakSelf.youSendCell setCurrencies:[self.objectModel fetchedControllerForSources]];
            }
        }
        
    }];

    [operation setObjectModel:self.objectModel];
    [operation execute];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kRowYouSend)
	{
        return self.youSendCell;
    }

    return self.theyReceiveCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == kRowYouSend)
	{
        [self.youSendCell.moneyField becomeFirstResponder];
    }
	else
	{
        [self.theyReceiveCell.moneyField becomeFirstResponder];
    }
}

-(void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)loginPressed:(id)sender
{
	LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)startPaymentPressed:(id)sender
{
    if (!self.result)
	{
        return;
    }
    
    [self.view endEditing:YES];

	Currency *sourceCurrency = [self.youSendCell currency];
    Currency *targetCurrency = [self.theyReceiveCell currency];
    NSString *profile = [self.objectModel currentUser].sendAsBusinessDefaultSettingValue? BUSINESS_PROFILE:PERSONAL_PROFILE;
    
    self.paymentHelper = [[NewPaymentHelper alloc] init];
    
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];
    
    [self.paymentHelper createPendingPaymentWithObjectModel:self.objectModel source:sourceCurrency target:targetCurrency calculationResult:self.result recipient:self.recipient profile:profile successBlock:^(PendingPayment *payment) {
        self.paymentHelper = nil;
        [hud hide];
        PaymentFlowViewControllerFactory *controllerFactory = [[PaymentFlowViewControllerFactory alloc] initWithObjectModel:self.objectModel];
        ValidatorFactory *validatorFactory = [[ValidatorFactory alloc] initWithObjectModel:self.objectModel];
        
        PaymentFlow *paymentFlow = [Credentials userLoggedIn] ? [[LoggedInPaymentFlow alloc] initWithPresentingController:self.navigationController
                                                                                         paymentFlowViewControllerFactory:controllerFactory
                                                                                                         validatorFactory:validatorFactory]
                                                                 :[[NoUserPaymentFlow alloc] initWithPresentingController:self.navigationController
                                                                                         paymentFlowViewControllerFactory:controllerFactory
                                                                                                         validatorFactory:validatorFactory];
        [self setPaymentFlow:paymentFlow];
        
        [[GoogleAnalytics sharedInstance] sendAppEvent:GACurrency1Selected withLabel:[self.youSendCell currency].code];
        [[GoogleAnalytics sharedInstance] sendAppEvent:GACurrency2Selected withLabel:[self.theyReceiveCell currency].code];
        
        
        [NavigationBarCustomiser setDefault];
        
        [paymentFlow setObjectModel:self.objectModel];
        [paymentFlow presentNextPaymentScreen];
    } failureBlock:^(NSError *error) {
        self.paymentHelper = nil;
        [hud hide];
        if (error.code == PayInTooLow)
        {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.low.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.low.message.base", nil), error.userInfo[NewTransferMinimumAmountKey], error.userInfo[NewTransferSourceCurrencyCodeKey]]];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];

        }
        else if (error.code == PayInTooLow)
        {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.high.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.high.message.base", nil), error.userInfo[NewTransferMaximumAmountKey], error.userInfo[NewTransferSourceCurrencyCodeKey]]];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
        }
        else if(error.code == USDPayinTooLow)
        {
            CustomInfoViewController *customInfo = [[CustomInfoViewController alloc] init];
            customInfo.titleText = NSLocalizedString(@"usd.low.title",nil);
            customInfo.infoText = NSLocalizedString(@"usd.low.info",nil);
            customInfo.actionButtonTitles= @[NSLocalizedString(@"usd.low.dismiss",nil)];
            customInfo.infoImage = [UIImage imageNamed:@"illustration_under1500usd"];
            [customInfo presentOnViewController:self];
            return;
        }
        else if(error.code == CurrenciesOperationFailed || error.code == RecipientTypesOperationFailed || error.code == CalculationOperationFailed)
        {
            NSError *networkError = error.userInfo[NewTransferNetworkOperationErrorKey];
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipient.types.load.error.title", nil) error:networkError];
            [alertView show];
            return;
        }

    }];
}

- (IBAction)howButtonTapped:(id)sender {
    SeeHowViewController * whyController = [[SeeHowViewController alloc] init];
    [whyController.whyView setupWithResult:self.result];
    [whyController presentOnViewController:self];
}

- (IBAction)closeModalTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCalculationIndicator:(BOOL)calculating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.startedButton showCalculating:calculating];
    });
}

-(void)updateApperanceAnimated:(BOOL)animated
{
    if (self.result.isFixedTargetPayment)
    {
        [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.title", nil)];
        if(self.recipient)
        {
            [self.theyReceiveCell setTitle:[NSString stringWithFormat:NSLocalizedString(@"money.entry.recipient.receive.exactly.title", nil),self.recipient.name]];
        }
        else
        {
            [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.exactly.title", nil)];
        }
    }
    else
    {
        [self.youSendCell setTitle:NSLocalizedString(@"money.entry.you.send.exactly.title", nil)];
        if(self.recipient)
        {
            [self.theyReceiveCell setTitle:[NSString stringWithFormat:NSLocalizedString(@"money.entry.recipient.receive.title", nil),self.recipient.name]];
        }
        else
        {
            [self.theyReceiveCell setTitle:NSLocalizedString(@"money.entry.they.receive.title", nil)];
        }
    }
    
    [self.theyReceiveCell setTitleHighlighted:self.result.isFixedTargetPayment];
    [self.youSendCell setTitleHighlighted:!self.result.isFixedTargetPayment];
    
    PairTargetCurrency* targetCurrency =  [self.objectModel pairTargetWithSource:self.youSendCell.currency target:self.theyReceiveCell.currency];
    [self.theyReceiveCell setEditable:targetCurrency.fixedTargetPaymentAllowedValue];
    
    if([self.youSendCell.currency.code isEqualToString:@"USD"])
    {
        if(self.termsBottomConstraint.constant != 4)
        {
            self.termsLabel.hidden = NO;
            self.termsBottomConstraint.constant = -100;
            [self.termsLabel layoutIfNeeded];
            self.termsBottomConstraint.constant = 4;
            self.howButtonTopConstraint.constant = 20;
        }
    }
    else
    {
        self.termsBottomConstraint.constant = -100;
        self.termsLabel.hidden = YES;
        self.howButtonTopConstraint.constant = 30;
    }
    if(animated)
    {
        [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.howButton layoutIfNeeded];
            [self.termsLabel layoutIfNeeded];
        } completion:nil];
    }
    else
    {
        [self.howButton layoutIfNeeded];
        [self.termsLabel layoutIfNeeded];
    }
    
    
}

@end
