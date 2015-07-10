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
#import "ApplePayCell.h"
@import PassKit;
#import "PullPaymentDetailsOperation.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "TransferDetailsViewController.h"
#import "PushNotificationsHelper.h"

#define PaymentMethodCellName @"PaymentMethodCell"
#define ApplePayCellName @"ApplePayCell"

#define APPLE_PAY @"APPLE_PAY"

@interface PaymentMethodSelectorViewController () <UITableViewDataSource, PaymentMethodCellDelegate, ApplePayCellDelegate, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) NSArray* sortedPayInMethods;

@property (nonatomic) ApplePayHelper *applePayHelper;

@property (nonatomic, strong) PullPaymentDetailsOperation *paymentDetailsOperation;

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
	
	
	self.sortedPayInMethods = [[self.payment enabledPayInMethods] sortedArrayUsingComparator:^NSComparisonResult(PayInMethod *method1, PayInMethod *method2) {
			return [[[PayInMethod supportedPayInMethods] objectForKeyedSubscript:method1.type]integerValue] > [[[PayInMethod supportedPayInMethods] objectForKey:method2.type] integerValue];
	}];
	
	if ([ApplePayHelper isApplePayAvailableForPayment: self.payment])
	{
		NSMutableArray *payInMethods = [[NSMutableArray alloc] initWithCapacity:self.sortedPayInMethods.count + 1];
		[payInMethods addObjectsFromArray:self.sortedPayInMethods];
		
		[payInMethods addObject:APPLE_PAY];
		
		self.sortedPayInMethods = payInMethods;
	}
	
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
	id payInMethod = self.sortedPayInMethods[indexPath.row];
	
	if ([payInMethod isKindOfClass:[PayInMethod class]])
	{
		PaymentMethodCell *cell = (PaymentMethodCell*) [tableView dequeueReusableCellWithIdentifier:PaymentMethodCellName];
		[cell configureWithPaymentMethod:self.sortedPayInMethods[indexPath.row]
							fromCurrency:[self.payment sourceCurrency].code];
		
		[self setCellBackground:indexPath
						   cell:cell];
		cell.paymentMethodCellDelegate = self;
		
		return cell;
	}
	else
	{
		ApplePayCell *cell = (ApplePayCell *)[tableView dequeueReusableCellWithIdentifier:ApplePayCellName];
		
		[self setCellBackground:indexPath
						   cell:cell];
		cell.applePayCellDelegate = self;
		
		return cell;
	}
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
					 withMethod:(PayInMethod *)method
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

- (void) payButtonTappedOnCell:(ApplePayCell *)cell
{
    // Create a new helper
    self.applePayHelper = [ApplePayHelper new];
    
    // Create the payment request from our helper
    PKPaymentRequest *paymentRequest = [self.applePayHelper createPaymentRequestForPayment: self.payment];
    
    UIViewController *paymentAuthorizationViewController;
    
    paymentAuthorizationViewController = [self.applePayHelper createAuthorizationViewControllerForPaymentRequest: paymentRequest
																										delegate: self];
    
    // Check to see if we could create an authorisation controller
    if (!paymentAuthorizationViewController)
    {
        // We didn't create an apple pay authorisation controller, so display an error screen
        [self presentCustomInfoWithSuccess: NO
                                controller: self
                                messageKey: @"applepay.failure.message.initcontroller"];
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
    // First we need to get this payment info a format suitable to passing to Adyen
    PKPaymentToken *paymentToken = payment.token;
    NSString *remoteIdString = [NSString stringWithFormat: @"%@",  self.payment.remoteId];
    
    [self.applePayHelper sendToken: paymentToken
                      forPaymentId: remoteIdString
                   responseHandler: ^(NSError *error, NSDictionary *result) {
					   
					   NSString* resultCode = result[@"resultCode"];
                       
					   if (!error
						   && [@"Authorised" caseInsensitiveCompare: resultCode] == NSOrderedSame)
					   {
						   completion(PKPaymentAuthorizationStatusSuccess);
						   
						   [self presentCustomInfoWithSuccess: YES
												   controller: self
												   messageKey: @"applepay.success.message"];
					   }
					   else
					   {
						   completion(PKPaymentAuthorizationStatusFailure);
						   
						   NSString *errorKeyPrefix = @"applepay.failure.message";
						   NSString *errorKeySuffix = @"initcontroller";
						   
						   if (resultCode
							   && [@"Received" caseInsensitiveCompare: resultCode] != NSOrderedSame
							   && [@"RedirectShopper" caseInsensitiveCompare: resultCode] != NSOrderedSame)
						   {
							   errorKeySuffix = [resultCode lowercaseString];
						   }
						   
						   [self presentCustomInfoWithSuccess: NO
												   controller: self
												   messageKey: [NSString stringWithFormat:@"%@.%@", errorKeyPrefix, errorKeySuffix]];
					   }
				   }];
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
{
    CustomInfoViewController *customInfo;
    
    if (success)
    {
        customInfo = [CustomInfoViewController successScreenWithMessage: messageKey];
        __weak typeof(self) weakSelf = self;
        __weak typeof(customInfo) weakCustomInfo = customInfo;
        __block BOOL shouldAutoDismiss = YES;
        __block BOOL paymentDetailsCompletedSuccessfully = NO;
        __block TRWProgressHUD *hud;
        
        ActionButtonBlock action = ^{
            shouldAutoDismiss = NO;
            if(weakSelf.paymentDetailsOperation)
            {
                hud = [TRWProgressHUD showHUDOnView:weakCustomInfo.view];
            }
            else
            {
                [hud hide];
                if(paymentDetailsCompletedSuccessfully)
                {
                    TransferDetailsViewController *details = [[TransferDetailsViewController alloc] init];
                    details.payment = weakSelf.payment;
                    details.objectModel = self.objectModel;
                    details.showClose = YES;
                    details.promptForNotifications = [PushNotificationsHelper shouldPresentNotificationsPrompt];
                    details.showRateTheApp = YES;
                   
                    [self.navigationController pushViewController:details animated:NO];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil userInfo:@{@"paymentId":weakSelf.payment.remoteId}];
                }
                [weakCustomInfo dismiss];
            }
        };
        
        customInfo.actionButtonBlocks = @[action];
        
        PullPaymentDetailsOperation *operation = [PullPaymentDetailsOperation operationWithPaymentId:[self.payment remoteId]];
        self.paymentDetailsOperation = operation;
        [operation setObjectModel:self.objectModel];
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.paymentDetailsOperation = nil;
                
                if (!error) {
                    paymentDetailsCompletedSuccessfully = YES;
                }
                BOOL preTimerShouldDismiss = shouldAutoDismiss;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(shouldAutoDismiss?5:0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(preTimerShouldDismiss == shouldAutoDismiss)
                    {
                        action();
                    }
                });
            });
        }];
        [operation execute];
        
    }
    else
    {
        customInfo = [CustomInfoViewController failScreenWithMessage: messageKey];
    }

    // Blurry overlay
    [customInfo presentOnViewController: controller.parentViewController
                  withPresentationStyle: TransparentPresentationFade];
    
    
}


@end
