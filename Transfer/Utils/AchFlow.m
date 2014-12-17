//
//  AchFlow.m
//  Transfer
//
//  Created by Juhan Hion on 20.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchFlow.h"
#import "Constants.h"
#import "TRWProgressHUD.h"
#import "AchDetailsViewController.h"
#import "VerificationFormOperation.h"
#import "Payment.h"
#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"
#import "AchLoginViewController.h"
#import "AchWaitingViewController.h"
#import "CustomInfoViewControllerDelegateHelper.h"
#import "VerifyFormOperation.h"
#import "TransferWaitingViewController.h"
#import "FeedbackCoordinator.h"
#import "ObjectModel+Payments.h"
#import "UIViewController+SwitchToViewController.h"
#import "NSError+TRWErrors.h"
#import "GoogleAnalytics.h"

#define WAIT_SCREEN_MIN_SHOW_TIME	2

#define VERIFICATION_FAILURE	@"VERIFICATION_FAILED"
#define ACCOUNT_NUMBER_MISMATCH	@"ACCOUNT_NUMBER_MISMATCH"

@class AchBank;

@interface AchFlow ()

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) CustomInfoViewControllerDelegateHelper *currentWaitingDelegate;
@property (nonatomic, strong) AchWaitingViewController *waitingViewController;
@property (nonatomic, copy) TRWActionBlock successHandler;

@end

@implementation AchFlow
{
	//flag to signalise that the operation has been cancelled
	__block BOOL isCancelled;
	//timer to track how much time waiting screen has been shown
	__block CFAbsoluteTime time;
}

#pragma mark - Init
+ (AchFlow *)sharedInstanceWithPayment:(Payment *)payment
						   objectModel:(ObjectModel *)objectModel
						successHandler:(void (^)())successHandler
{
	static dispatch_once_t pred = 0;
	__strong static AchFlow *sharedObject = nil;
	dispatch_once(&pred, ^{
		sharedObject = [[self alloc] initSingleton];
	});
	
	sharedObject.payment = payment;
	sharedObject.objectModel = objectModel;
	
	return sharedObject;
}

- (id)initSingleton
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

#pragma mark - Flow
- (UIViewController *)getAccountAndRoutingNumberController
{
	[[GoogleAnalytics sharedInstance] sendScreen:@"ACH step 1 shown"];
	return [[AchDetailsViewController alloc] initWithPayment:self.payment
											  loginFormBlock:^(NSString *accountNumber, NSString *routingNumber, UINavigationController *controller) {
												  [[GoogleAnalytics sharedInstance] sendScreen:@"ACH waiting 1 shown"];
												  
												  __weak typeof(self) weakSelf = self;
												  [self setOperationWithNavigationController:controller
																			  operationBlock:^TransferwiseOperation *{
																				  return [VerificationFormOperation verificationFormOperationWithAccount:accountNumber
																																		   routingNumber:routingNumber
																																			   paymentId:weakSelf.payment.remoteId];
																			  }
																   waitingScreenMessageBlock:^NSString *{
																	   return NSLocalizedString(@"ach.waiting.info", nil);
																   }
																						flow:weakSelf];
											   
												  [(VerificationFormOperation *)self.executedOperation setResultHandler:^(NSError *error, AchBank *form) {
													  [weakSelf handleResultWithError:error
																		successBlock:^{
																			UIViewController *loginController = [weakSelf getLoginForm:form];
																			[controller pushViewController:loginController animated:YES];
																		}
																	  trackErrorBlock:^(NSString* messages){
																		  [[GoogleAnalytics sharedInstance] sendAlertEvent:@"FindingUSaccountAlert"
																												 withLabel:messages];
																	  }
																				flow:weakSelf];
												  }];
												  
												  [self.executedOperation execute];
											  }];
}

- (UIViewController *)getLoginForm:(AchBank *)form
{
	[[GoogleAnalytics sharedInstance] sendScreen:@"ACH step 2 shown"];
	return [[AchLoginViewController alloc] initWithForm:form
												payment:self.payment
											objectModel:self.objectModel
										   initiatePull:^(NSDictionary *form, UINavigationController *controller){
											   [[GoogleAnalytics sharedInstance] sendScreen:@"ACH waiting 2 shown"];
											   
											   __weak typeof(self) weakSelf = self;
											   [self setOperationWithNavigationController:controller
																		   operationBlock:^TransferwiseOperation *{
																			   return [VerifyFormOperation verifyFormOperationWithData:form];
																		   }
																waitingScreenMessageBlock:^NSString *{
																	return NSLocalizedString(@"ach.waiting.info2", nil);
																}
																					 flow:weakSelf];
											   
											   [(VerifyFormOperation *)self.executedOperation setResultHandler:^(NSError *error, BOOL success) {
												   //handle known errors
												   if (error)
												   {
													   if ([error containsTwCode:VERIFICATION_FAILURE])
													   {
														   [[GoogleAnalytics sharedInstance] sendAlertEvent:@"PullingUSaccountAlert"
																								  withLabel:@"Account verification failed"];
														   [weakSelf presentCustomInfoWithSuccess:NO
																					   controller:controller
																						  message:@"ach.failure.message.account"
																					  actionBlock:^{
																						  weakSelf.currentWaitingDelegate.completion = ^{
																							  [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
																						  };
																						  
																						  [weakSelf.waitingViewController dismiss];
																					  }
																					 successBlock:nil
																							 flow:weakSelf];
														   return;
													   }
													   else if ([error containsTwCode:ACCOUNT_NUMBER_MISMATCH])
													   {
														   [[GoogleAnalytics sharedInstance] sendAlertEvent:@"PullingUSaccountAlert"
																								  withLabel:@"Account number mismatch"];
														   [weakSelf presentCustomInfoWithSuccess:NO
																					   controller:controller
																						  message:@"ach.failure.message.mismatch"
																					  actionBlock:^{
																						  weakSelf.currentWaitingDelegate.completion = ^{
																							  //account number mismatch means that user needs to recheck their entered routing/account numbers
																							  [controller popViewControllerAnimated:YES];
																						  };
																						  
																						  [weakSelf.waitingViewController dismiss];
																					  }
																					 successBlock:nil
																							 flow:weakSelf];
														   return;
													   }
												   }
												   
												   //no known errors so let standard handler deal with it
												   [weakSelf handleResultWithError:error
																	  successBlock:^{
																		  [[GoogleAnalytics sharedInstance] sendScreen:@"ACH success shown"];
																		  [weakSelf presentCustomInfoWithSuccess:YES
																									  controller:controller
																										 message:@"ach.success.message"
																									 actionBlock:^{
																										 if (IPAD)
																										 {
																											 [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
																										 }
																										 else
																										 {
																											 TransferWaitingViewController *waitingController = [TransferWaitingViewController endOfFlowInstanceForPayment:weakSelf.payment
																																																			   objectModel:weakSelf.objectModel];
																											 [controller.topViewController switchToViewController:waitingController];
																										 }
																									 }
																									successBlock:^{
																										[weakSelf.objectModel performBlock:^{
																											[weakSelf.objectModel togglePaymentMadeForPayment:weakSelf.payment payInMethodName:@"ACH"];
																										}];
																									}
																											flow:weakSelf];
																		}
																   trackErrorBlock:^(NSString* messages){
																		[[GoogleAnalytics sharedInstance] sendAlertEvent:@"PullingUSaccountAlert"
																											   withLabel:messages];
																   }
																			  flow:weakSelf];
											   }];
											   
											   [self.executedOperation execute];
										   }];
}

- (void)setOperationWithNavigationController:(UINavigationController *)controller
							  operationBlock:(TransferwiseOperation *(^)())operationBlock
				   waitingScreenMessageBlock:(NSString *(^)())waitingScreenMessageBlock
										flow:(AchFlow *)flow

{
	//this is the entrypoint so we are definetly not cancelled
	isCancelled = NO;
	
	//need to track time that waiting screen is displayed for at least some time
	time = CFAbsoluteTimeGetCurrent();
	
	//keep strong reference to operation
	self.executedOperation = operationBlock();
	self.executedOperation.objectModel = self.objectModel;
	
	//set up wait view delegate with cancel
	CustomInfoViewControllerDelegateHelper *delegate = [[CustomInfoViewControllerDelegateHelper alloc] initWithCompletion:^{
		isCancelled = YES;
		[flow.executedOperation cancel];
	}];
	//keep strong reference
	self.currentWaitingDelegate = delegate;
	
	//init and show waiting view
	self.waitingViewController = [[AchWaitingViewController alloc] init];
	self.waitingViewController.infoText = waitingScreenMessageBlock();
	self.waitingViewController.delegate = delegate;
	[self.waitingViewController presentOnViewController:controller.parentViewController
								  withPresentationStyle:TransparentPresentationFade];
}

- (void)handleResultWithError:(NSError *)error
				 successBlock:(void (^)())successBlock
			  trackErrorBlock:(void (^)(NSString* messages))trackErrorBlock
						 flow:(AchFlow *)flow
{
	//operation might have been cancelled before reaching here
	//but it might not have
	if (self -> isCancelled)
	{
		return;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
        if (error)
		{
			NSString *messages = nil;
			
			if (error && [error isTransferwiseError])
			{
				messages = [error localizedTransferwiseMessage];
			}
			
			trackErrorBlock(messages);
			
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.accessing.error", nil) message:messages];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[self.waitingViewController dismiss];
			[alertView show];
			return;
		}
		
		//override completion here because we have succeeded
		flow.currentWaitingDelegate.completion = ^{
			//could have been cancelled even now
			if (isCancelled)
			{
				return;
			}
			
			//if you are really quick You can have method be invoked twice
			isCancelled = YES;
			successBlock();
		};
		
		//if we have been faster than expected delay wait screen removal so user can read it
		time = CFAbsoluteTimeGetCurrent() - time;
		time = time < WAIT_SCREEN_MIN_SHOW_TIME ? WAIT_SCREEN_MIN_SHOW_TIME - time : 0;
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.waitingViewController dismiss];
		});
	});
}

- (void)presentCustomInfoWithSuccess:(BOOL)success
						  controller:(UINavigationController *)controller
							 message:(NSString *)message
						 actionBlock:(void (^)())actionBlock
						successBlock:(void (^)())successBlock
								flow:(AchFlow *)flow
{
	CustomInfoViewController * customInfo;
	
	if (success)
	{
		customInfo = [CustomInfoViewController successScreenWithMessage:message];
	}
	else
	{
		customInfo = [CustomInfoViewController failScreenWithMessage:message];
	}
	
	__weak typeof(customInfo) weakCustomInfo = customInfo;
	__block BOOL shouldAutoDismiss = YES;
	customInfo.actionButtonBlock = ^{
		shouldAutoDismiss = NO;
		
		if (actionBlock)
		{
			actionBlock();
		}
		
		[weakCustomInfo dismiss];
	};
	
	if (successBlock)
	{
		successBlock();
	}
	
	[customInfo presentOnViewController:controller.parentViewController withPresentationStyle:TransparentPresentationFade];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if(shouldAutoDismiss)
		{
			weakCustomInfo.actionButtonBlock();
		}
	});
}

@end
