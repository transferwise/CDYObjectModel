//
//  ApplePayFlow.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayFlow.h"
#import "ApplePayHelper.h"
#import "Payment.h"
#import "AdyenResponseParser.h"
#import "CustomInfoViewController.h"
#import "CustomInfoViewController+UpdatePaymentDetails.h"
#import "GoogleAnalytics.h"
#import "Mixpanel+Customisation.h"
#import "AnalyticsConstants.h"
@import PassKit;

@interface ApplePayFlow () <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, copy) TRWActionBlock successHandler;
@property (nonatomic, strong) ApplePayHelper *applePayHelper;
@property (nonatomic, weak) UIViewController *hostingController;

@end

@implementation ApplePayFlow

#pragma mark - Init
+ (ApplePayFlow *)sharedInstanceWithPayment:(Payment *)payment
								objectModel:(ObjectModel *)objectModel
							 successHandler:(TRWActionBlock)successHandler
					  hostingViewController:(UIViewController *)hostingViewController
{
	static dispatch_once_t pred = 0;
	__strong static ApplePayFlow *sharedObject = nil;
	dispatch_once(&pred, ^{
		sharedObject = [[self alloc] initSingleton];
	});
	
	sharedObject.payment = payment;
	sharedObject.objectModel = objectModel;
	sharedObject.successHandler = successHandler;
	sharedObject.hostingController = hostingViewController;
	
	return sharedObject;
}

- (instancetype)initSingleton
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

#pragma mark - Handle Apple Pay
- (void)handleApplePay
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
		[CustomInfoViewController presentCustomInfoWithSuccess: NO
													controller: self.hostingController
													messageKey: @"applepay.failure.message.initcontroller"
													   payment: self.payment
												   objectModel: self.objectModel];
	}
	else
	{
		// Track!!!
		[[GoogleAnalytics sharedInstance] sendScreen:GAApplePayShown];
		[[Mixpanel sharedInstance] sendPageView:MPApplePay];
		
		// Show Apple Pay slideup
		[self.hostingController presentViewController: paymentAuthorizationViewController
											 animated: YES
										   completion: nil];
	}
}

#pragma mark - Apple Pay Delegate
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
					   [AdyenResponseParser handleAdyenResponse:error
													   response:result
												 successHandler:^{
													 completion(PKPaymentAuthorizationStatusSuccess);
													 // Track!!!
													 [[GoogleAnalytics sharedInstance] sendScreen:GAApplePaySuccessShown];
													 [[Mixpanel sharedInstance] sendPageView:MPApplePaySuccess];
													 
													 [CustomInfoViewController presentCustomInfoWithSuccess: YES
																								 controller: self.hostingController
																								 messageKey: @"applepay.success.message"
																									payment: self.payment
																								objectModel: self.objectModel];
												 }
													failHandler:^(NSError *error, NSString *errorKeySuffix) {
														completion(PKPaymentAuthorizationStatusFailure);
														
														NSString *errorKeyPrefix = @"applepay.failure.message";
														errorKeySuffix = errorKeySuffix ?: @"initcontroller";
														
														[[GoogleAnalytics sharedInstance] sendAlertEvent:GAApplePayFail
																							   withLabel:errorKeySuffix];
														
														[CustomInfoViewController presentCustomInfoWithSuccess: NO
																									controller: self.hostingController
																									messageKey: [NSString stringWithFormat:@"%@.%@", errorKeyPrefix, errorKeySuffix]
																									   payment: self.payment
																								   objectModel: self.objectModel];
													}];
				   }];
}

/**
 *  Finshed with PKPaymentAuthorizationViewController, so dismiss it
 *
 *  @param controller PKPaymentAuthorizationViewController
 */

- (void) paymentAuthorizationViewControllerDidFinish: (PKPaymentAuthorizationViewController *) controller
{
	[self.hostingController dismissViewControllerAnimated: YES
											   completion: nil];
}

@end
