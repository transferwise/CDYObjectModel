//
//  PaymentMethodSelectorViewController.m
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayHelper.h"
#import "Currency.h"
#import "CustomInfoViewController.h"
#import "GoogleAnalytics.h"
#import "MOMStyle.h"
#import "Mixpanel+Customisation.h"
#import "PayInMethod.h"
#import "Payment.h"
#import "PaymentMethodCell.h"
#import "PaymentMethodSelectorViewController.h"
#import "TransferBackButtonItem.h"
#import "UploadMoneyViewController.h"
@import PassKit;

#define PaymentMethodCellName @"PaymentMethodCell"

@interface PaymentMethodSelectorViewController () <UITableViewDataSource, PaymentMethodCellDelegate, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *applePayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applePayViewHeightContraint;

@property (nonatomic) NSArray* sortedPayInMethods;

@property (nonatomic) ApplePayHelper *applePayHelper;

@end

@implementation PaymentMethodSelectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat applePayViewHeight = 0.0;
    
    // If we support Apple pay (iOS 8 and above) then we will need to display the button at the bottom of the screen
    if ([ApplePayHelper isApplePayAvailableForPayment: self.payment])
    {
        // Pay is available
        // Retain the view height
        applePayViewHeight = self.applePayViewHeightContraint.constant;
        
        // Now create out custom button and center it in the applePayView
        UIButton *applePayButton = [PKPaymentButton buttonWithType: PKPaymentButtonTypeBuy style: PKPaymentButtonStyleWhiteOutline];
        [applePayButton addTarget: self action: @selector(userTouchedApplePayButton:) forControlEvents: UIControlEventTouchUpInside];

        // Hideous nonsense to ensure that button is centered correctly
        [applePayButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.applePayView addSubview: applePayButton];
        
        NSLayoutConstraint* cn = [NSLayoutConstraint constraintWithItem: applePayButton
                                                              attribute: NSLayoutAttributeCenterX
                                                              relatedBy: NSLayoutRelationEqual
                                                                 toItem: self.applePayView
                                                              attribute: NSLayoutAttributeCenterX
                                                             multiplier: 1.0
                                                               constant: 0];
        [self.view addConstraint: cn];
        cn = [NSLayoutConstraint constraintWithItem: applePayButton
                                          attribute: NSLayoutAttributeCenterY
                                          relatedBy: NSLayoutRelationEqual
                                             toItem: self.applePayView
                                          attribute: NSLayoutAttributeCenterY
                                         multiplier: 1.0
                                           constant: 0];
        [self.view addConstraint: cn];
    }
    
    // Hide the Pay view if required
    self.applePayViewHeightContraint.constant = applePayViewHeight;
    
    UINib *nib = [UINib nibWithNibName:PaymentMethodCellName bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:nib forCellReuseIdentifier:PaymentMethodCellName];
    [self setTitle:NSLocalizedString(@"upload.money.title.single.method",nil)];
	self.sortedPayInMethods = [[self.payment enabledPayInMethods] sortedArrayUsingComparator:^NSComparisonResult(PayInMethod *method1, PayInMethod *method2) {
			return [[[PayInMethod supportedPayInMethods] objectForKeyedSubscript:method1.type]integerValue] > [[[PayInMethod supportedPayInMethods] objectForKey:method2.type]integerValue];
	}];
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

#pragma mark - Apple Pay support

/**
 *  The user touched the Apple Pay button
 *
 *  @param button Button
 */

- (void) userTouchedApplePayButton: (UIButton *) button
{
    // Create a new helper
    self.applePayHelper = [ApplePayHelper new];
    
    // Create the payment request from our helper
    PKPaymentRequest *paymentRequest = [self.applePayHelper createPaymentRequestForPayment: self.payment];
    
    UIViewController *paymentAuthorizationViewController;
    
    paymentAuthorizationViewController = [self.applePayHelper createAuthorizationViewControllerForPaymentRequest: paymentRequest delegate: self];
    
    // Check to see if we could create an authorisation controller
    if (!paymentAuthorizationViewController)
    {
        // We didn't create an apple pay authorisation controller, so display an error screen
        [self presentCustomInfoWithSuccess: NO
                                controller: self
                                messageKey: @"applepay.failure.message.initcontroller"
                               actionBlock: nil
                              successBlock: nil];
    }
    else
    {
        // Show Apple Pay slideup
        [self presentViewController: paymentAuthorizationViewController
                           animated: YES
                         completion: nil];
    }
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate

/**
 *  Apple Pay authorised this payment
 *
 *  @param controller PKPaymentAuthorizationViewController
 *  @param payment    The payment
 *  @param completion Block to callback with a status code when payment is completed
 */

- (void) paymentAuthorizationViewController: (PKPaymentAuthorizationViewController *) controller
                        didAuthorizePayment: (PKPayment *) payment
                                 completion: (void (^)(PKPaymentAuthorizationStatus status)) completion
{
    BOOL authorizationSuccessful = YES;
    
    // First we need to get this payment info a format suitable to passing to Adyen
    PKPaymentToken *paymentToken = payment.token;
    
    if (authorizationSuccessful)
    {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        [self presentCustomInfoWithSuccess: YES
                                controller: self
                                messageKey: @"applepay.success.message"
                               actionBlock: nil
                              successBlock: nil];
    }
    else
    {
        completion(PKPaymentAuthorizationStatusFailure);
        
        [self presentCustomInfoWithSuccess: NO
                                controller: self
                                messageKey: @"applepay.failure.message.initcontroller"
                               actionBlock: nil
                              successBlock: nil];
    }
}

/**
 *  Finshed with PKPaymentAuthorizationViewController, so dismiss it
 *
 *  @param controller PKPaymentAuthorizationViewController
 */

- (void) paymentAuthorizationViewControllerDidFinish: (PKPaymentAuthorizationViewController *) controller
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

/**
 *  Apple Pay success/failure screen
 *
 *  @param success      Authentication/
 *  @param controller   Navigation controller
 *  @param message      MessageKey
 *  @param actionBlock  action
 *  @param successBlock success
 */

- (void) presentCustomInfoWithSuccess: (BOOL) success
                           controller: (UIViewController *) controller
                           messageKey: (NSString *) messageKey
                          actionBlock: (void (^)()) actionBlock
                         successBlock: (void (^)()) successBlock
{
    CustomInfoViewController *customInfo;
    
    if (success)
    {
        customInfo = [CustomInfoViewController successScreenWithMessage: messageKey];
    }
    else
    {
        customInfo = [CustomInfoViewController failScreenWithMessage: messageKey];
    }
    
    __weak typeof(customInfo) weakCustomInfo = customInfo;
    __block BOOL shouldAutoDismiss = YES;
    
    ActionButtonBlock action = ^{
        shouldAutoDismiss = NO;
        
        if (actionBlock) { actionBlock(); }
        
        [weakCustomInfo dismiss];
    };
    
    customInfo.actionButtonBlocks = @[action];
    
    if (successBlock) { successBlock(); }
    
    // Blurry overlay
    [customInfo presentOnViewController: controller.parentViewController
                  withPresentationStyle: TransparentPresentationFade];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(shouldAutoDismiss)
        {
            action();
        }
    });
}


@end
