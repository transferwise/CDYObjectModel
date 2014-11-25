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

@class AchBank;

@interface AchFlow ()

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation AchFlow

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

- (UIViewController *)getAccountAndRoutingNumberController
{
	return [[AchDetailsViewController alloc] initWithPayment:self.payment
											  loginFormBlock:^(NSString *accountNumber, NSString *routingNumber, TRWProgressHUD *hud, UINavigationController *controller) {
												  VerificationFormOperation *operation = [VerificationFormOperation verificationFormOperationWithAccount:accountNumber
																																		   routingNumber:routingNumber
																																			   paymentId:self.payment.remoteId];
												  operation.objectModel = self.objectModel;
												  self.executedOperation = operation;
												  __weak typeof(self) weakSelf = self;
												  [operation setResultHandler:^(NSError *error, AchBank *form) {
													  dispatch_async(dispatch_get_main_queue(), ^{
														  [hud hide];
														  
														  if (error || !form)
														  {
															  NSString *messages = nil;
															  
															  if (error && [error isTransferwiseError])
															  {
																  messages = [error localizedTransferwiseMessage];
															  }
															  
															  TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.accessing.error", nil) message:messages];
															  [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
															  [alertView show];
															  return;
														  }
														  
														  UIViewController *loginController = [weakSelf getLoginForm:form];
														  [controller pushViewController:loginController animated:YES];
													  });
												  }];
												  
												  [operation execute];
											  }];
}

- (UIViewController *)getLoginForm:(AchBank *)form
{
	return [[AchLoginViewController alloc] initWithForm:form
												payment:self.payment
											objectModel:self.objectModel
										   initiatePull:^{
											   
										   }];
}

@end
