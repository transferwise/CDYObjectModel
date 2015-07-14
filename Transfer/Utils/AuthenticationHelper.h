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
					waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
touchIDHost:(UIViewController*)touchIdHost;

- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
                                     password:(NSString *)password
                           keepPendingPayment:(BOOL)keepPendingPayment
                     navigationControllerView:(UIView *)navigationControllerView
                                  objectModel:(ObjectModel *)objectModel
                                 successBlock:(TRWActionBlock)successBlock
                                   errorBlock:(void(^)(NSError* error))errorBlock
                    waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
                                  touchIDHost:(UIViewController*)touchIdHost;

- (void)performOAuthLoginWithProvider:(NSString *)providerName
				 navigationController:(UINavigationController *)navigationController
						  objectModel:(ObjectModel *)objectModel
					   successHandler:(TRWActionBlock)successBlock;

- (void)performFacebookLoginWithNavigationController:(UINavigationController *)navigationController
										 objectModel:(ObjectModel *)objectModel
									  successHandler:(TRWActionBlock)successBlock;

+ (void)revokeOauthAccessForProvider:(NSString*)provider completionBlock:(void (^)(void))completionBlock;

+ (void)proceedFromSuccessfulLoginFromViewController:(UIViewController*)controller
										 objectModel:(ObjectModel*)objectModel;

+ (void)logOutWithObjectModel:(ObjectModel *)objectModel
		   tokenNeedsClearing:(BOOL)clearToken
			  completionBlock:(void (^)(void))completionBlock;

+ (void)onePasswordLoginWithCompletion:(void(^)(BOOL success, NSString* username, NSString* password))completionBlock
					  onViewController:(UIViewController*)controller
								sender:(id)sender;

+ (void)onePasswordInsertRegistrationDetails:(void(^)(BOOL success, NSString* email, NSString* password))completionBlock
						  preEnteredUsername:(NSString*)email
						  preEnteredPassword:(NSString*)password
							  viewController:(UIViewController*)controller
									  sender:(id)sender;

+ (BOOL)onePasswordIsAvaliable;


@end
