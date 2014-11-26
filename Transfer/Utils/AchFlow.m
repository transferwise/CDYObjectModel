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

@class AchBank;

@interface AchFlow ()

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) CustomInfoViewControllerDelegateHelper *currentWaitingDelegate;

@end

@implementation AchFlow

#pragma mark - Init
+ (AchFlow *)sharedInstanceWithPayment:(Payment *)payment
						   objectModel:(ObjectModel *)objectModel
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
	return [[AchDetailsViewController alloc] initWithPayment:self.payment
											  loginFormBlock:^(NSString *accountNumber, NSString *routingNumber, UINavigationController *controller) {
												  //lots of delegates accessing self
												  __weak typeof(self) weakSelf = self;
												  
												  //set up operation first
												  VerificationFormOperation *operation = [VerificationFormOperation verificationFormOperationWithAccount:accountNumber
																																		   routingNumber:routingNumber
																																			   paymentId:self.payment.remoteId];
												  operation.objectModel = self.objectModel;
												  //keep strong reference
												  self.executedOperation = operation;
												  
												  __block BOOL isCancelled = NO;
												  
												  //set up wait view delegate with cancel
												  CustomInfoViewControllerDelegateHelper *delegate = [[CustomInfoViewControllerDelegateHelper alloc] initWithCompletion:^{
													  isCancelled = YES;
													  [weakSelf.executedOperation cancel];
												  }];
												  //keep strong reference
												  self.currentWaitingDelegate = delegate;
												  
												  //init and show waiting view
												  AchWaitingViewController *waitingViewController = [[AchWaitingViewController alloc] init];
												  waitingViewController.delegate = delegate;
												  [waitingViewController presentOnViewController:controller.parentViewController
																		   withPresentationStyle:TransparentPresentationFade];
												  
												  //add result handler that references delegate for completion
												  [operation setResultHandler:^(NSError *error, AchBank *form) {
													  //operation might have been cancelled before reaching here
													  //but it might not have
													  if (isCancelled)
													  {
														  return;
													  }
													  
													  dispatch_async(dispatch_get_main_queue(), ^{
														  if (error || !form)
														  {
															  NSString *messages = nil;
															  
															  if (error && [error isTransferwiseError])
															  {
																  messages = [error localizedTransferwiseMessage];
															  }
															  
															  TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.accessing.error", nil) message:messages];
															  [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
															  [waitingViewController dismiss];
															  [alertView show];
															  return;
														  }
														  
														  //override completion here because we have succeeded
														  weakSelf.currentWaitingDelegate.completion = ^{
															  //could have been cancelled even now
															  if (isCancelled)
															  {
																  return;
															  }
															  
															  //if you are really quick You can have method be invoked twice
															  isCancelled = YES;
															  UIViewController *loginController = [weakSelf getLoginForm:form];
															  [controller pushViewController:loginController animated:YES];
														  };
														  [waitingViewController dismiss];
													  });
												  }];
												  
												  //run the whole shebang
												  [operation execute];
											  }];
}

- (UIViewController *)getLoginForm:(AchBank *)form
{
	return [[AchLoginViewController alloc] initWithForm:form
												payment:self.payment
											objectModel:self.objectModel
										   initiatePull:^(UINavigationController* controller){
											   AchWaitingViewController *waitingViewController = [[AchWaitingViewController alloc] init];
												  [waitingViewController presentOnViewController:controller.parentViewController
																		   withPresentationStyle:TransparentPresentationFade];
										   }];
}

@end
