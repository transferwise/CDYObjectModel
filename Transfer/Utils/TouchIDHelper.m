//
//  TouchIDHelper.m
//  Transfer
//
//  Created by Mats Trovik on 08/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TouchIDHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Lockbox.h>
#import "TRWAlertView.h"

#define localUser @"localUser"
#define localPass @"localPass"
#define blockList @"blockList"

@implementation TouchIDHelper

+(LAContext*)getContextIfTouchIDAvailable
{
    if([LAContext class])
    {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            return myContext;
        }
    }
    return nil;
}

+(BOOL)isTouchIdSlotTaken
{
    NSString* localUserName = [Lockbox stringForKey:localUser];
    return ([localUserName length] >0) && ([self isTouchIdAvailable]);
}

+(BOOL)isTouchIdAvailable
{
    LAContext* context = [self getContextIfTouchIDAvailable];
    if(context)
    {
        return YES;
    }
    return NO;
}

+(void)validateTouchIDWithReason:(NSString*)reason completion:(void(^)(BOOL success, NSError * error))resultBlock
{
    LAContext* context = [self getContextIfTouchIDAvailable];
    context.localizedFallbackTitle = @"";
    if(context)
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                              resultBlock(success, error);
                          }];
    }
    else
    {
        resultBlock(NO, nil);
    }
}

+(BOOL)shouldPromptForUsername:(NSString*)username
{
    NSSet* nameSet = [Lockbox setForKey:blockList];
    return ![nameSet containsObject:username];
}

+(void)blockStorageForUsername:(NSString*)username
{
    NSMutableSet *blockedNameList = [[Lockbox setForKey:blockList] mutableCopy];
    if(!blockedNameList)
    {
        blockedNameList = [NSMutableSet set];
    }
    
    [blockedNameList addObject:username];
    [Lockbox setSet:blockedNameList forKey:blockList];
}

+(void)clearCredentials
{
    [Lockbox setString:@"" forKey:localUser];
    [Lockbox setString:@"" forKey:localPass];
}

+(void)clearCredentialsAfterValidation:(void(^)(BOOL success))resultBlock
{
        [self validateTouchIDWithReason:NSLocalizedString(@"touchid.reason.clear", nil) completion:^(BOOL success, NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{

                if(success)
                {
                    [Lockbox setString:@"" forKey:localUser];
                    [Lockbox setString:@"" forKey:localPass];
                }
                else if (error && error.code != kLAErrorUserCancel && error.code != kLAErrorSystemCancel)
                {
                    TRWAlertView* alert = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"touchid.alert.title", nil) message:[error localizedDescription]];
                    [alert setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alert show];
                }
                if(resultBlock)
                {
                    resultBlock(success);
                }
            });
    }];
}

+(void)clearBlockedUsernames
{
    [Lockbox setSet:[NSSet set] forKey:blockList];
}

+(void)storeCredentialsWithUsername:(NSString*)username password:(NSString*)password result:(void(^)(BOOL success))resultBlock
{
    [self validateTouchIDWithReason:NSLocalizedString(@"touchid.reason.store", nil) completion:^(BOOL success, NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success)
            {
                [Lockbox setString:username forKey:localUser];
                [Lockbox setString:password forKey:localPass];
            }
            else if (error && error.code != kLAErrorUserCancel && error.code != kLAErrorSystemCancel)
            {
                TRWAlertView* alert = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"touchid.alert.title", nil) message:[error localizedDescription]];
                [alert setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alert show];
            }
            resultBlock(success);
        });
        
    }];
}

+(void)retrieveStoredCredentials:(void(^)(BOOL success, NSString* username, NSString* password))resultBlock
{
    [self validateTouchIDWithReason:NSLocalizedString(@"touchid.reason.retrieve", nil) completion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* localUserName;
            NSString* localPassword;
            if(success)
            {
                localUserName = [Lockbox stringForKey:localUser];
                localPassword = [Lockbox stringForKey:localPass];
            }
            else if (error && error.code != kLAErrorUserCancel && error.code != kLAErrorSystemCancel)
            {
                TRWAlertView* alert = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"touchid.alert.title", nil) message:[error localizedDescription]];
                [alert setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alert show];
            }
            resultBlock(success, localUserName, localPassword);
        });
    }];
}

+(BOOL)isBlockedUserNameListEmpty
{
     NSSet *blockedNameList = [Lockbox setForKey:blockList];
    return [blockedNameList count] <= 0;
}


@end
