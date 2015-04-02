//
//  Authenticationhelper.h
//  Transfer
//
//  Created by Juhan Hion on 06.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ObjectModel;
@class TransferwiseOperation;

@interface AuthenticationHelper : NSObject

- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
									 password:(NSString *)password
                           keepPendingPayment:(BOOL)keepPendingPayment
					 navigationControllerView:(UIView *)navigationControllerView
								  objectModel:(ObjectModel *)objectModel
								 successBlock:(TRWActionBlock)successBlock
					waitForDetailsCompletions:(BOOL)waitForDetailsCompletion;

- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
                                     password:(NSString *)password
                           keepPendingPayment:(BOOL)keepPendingPayment
                     navigationControllerView:(UIView *)navigationControllerView
                                  objectModel:(ObjectModel *)objectModel
                                 successBlock:(TRWActionBlock)successBlock
                                   errorBlock:(void(^)(NSError* error))errorBlock
                    waitForDetailsCompletions:(BOOL)waitForDetailsCompletion;

- (void)preformOAuthLoginWithToken:(NSString *)token
						  provider:(NSString *)provider
				keepPendingPayment:(BOOL)keepPendingPayment
			  navigationController:(UINavigationController *)navigationController
					   objectModel:(ObjectModel *)objectModel
					  successBlock:(TRWActionBlock)successBlock
						errorBlock:(TRWActionBlock)errorBlock
		 waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
						  isSilent:(BOOL)isSilent;

+ (void)proceedFromSuccessfulLoginFromViewController:(UIViewController*)controller
										 objectModel:(ObjectModel*)objectModel;

+ (void)logOutWithObjectModel:(ObjectModel *)objectModel
		   tokenNeedsClearing:(BOOL)clearToken
			  completionBlock:(void (^)(void))completionBlock;

@end
