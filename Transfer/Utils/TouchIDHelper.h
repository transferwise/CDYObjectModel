//
//  TouchIDHelper.h
//  Transfer
//
//  Created by Mats Trovik on 08/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomInfoViewController;

@interface TouchIDHelper : NSObject


/**
 Checks if TouchId is avaialable to use on this device.
 @return YES if TouchID is supported, otherwise NO.
*/
+(BOOL)isTouchIdAvailable;

/**
 Checks if login credentials are already associated with the touchId.
 @return YES if credentials are associated, otherwise NO.
 */
+(BOOL)isTouchIdSlotTaken;

/**
 store login credentals by asking user to authenticate with touch ID.
 @param username 
 @param password
 @param resultBlock called with success indicating if the user authenticated and details were stored.
 */
+(void)storeCredentialsWithUsername:(NSString*)username password:(NSString*)password result:(void(^)(BOOL success))resultBlock;

/**
 retrieve stored credentials by asking user to authenticate with touch ID.
 @param resultblock called with success indicating successful retrieaval, and if successful username and password credentials.
*/
+(void)retrieveStoredCredentials:(void(^)(BOOL success, NSString* username, NSString* password))resultBlock;

/**
 Check if the user has previously been asked about storing these credentials.
 @return YES if the user has not been asked before.
 */
+(BOOL)shouldPromptForUsername:(NSString*)username;

/**
 Call to prevent touch Id association prompt from appearing again for this username.
*/
+(void)blockStorageForUsername:(NSString*)username;

/**
 call to clear any stored credentials.
 */
+(void)clearCredentials;

/**
 call to clear credentials and blocked user list if the user successfully authenticates with touchID
 
 @param resultBlock called with success indicating if the user authenticated and details were cleared.
 */
+(void)clearCredentialsAfterValidation:(void(^)(BOOL success))resultBlock;

/**
 call to clear the list of blocked usernames
 */
+(void)clearBlockedUsernames;

/**
 checks if any usernames are blocked
 */
+(BOOL)isBlockedUserNameListEmpty;

/**
 *  factory method for touchID prompt used to store user credentials in the key chain.
 *
 *  @param username        username to store
 *  @param password        password to store
 *  @param completionBlock an action to perfom after the prompt has been dismissed.
 *
 *  @return a configured CustomInfoViewController ready to present.
 */
+(CustomInfoViewController*)touchIdCustomInfoWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void(^)(void))completionBlock;
@end
