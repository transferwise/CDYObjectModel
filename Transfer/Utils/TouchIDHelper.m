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

#define localUser @"localUser"
#define localPass @"localUser"
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

+(void)validateTouchID:(void(^)(BOOL success))resultBlock
{
    LAContext* context = [self getContextIfTouchIDAvailable];
    if(context)
    {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:NSLocalizedString(@"touchid.reason", nil)
                          reply:^(BOOL success, NSError *error) {
                              resultBlock(success);
                          }];
    }
    else
    {
        resultBlock(NO);
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

+(void)storeCredentialsWithUsername:(NSString*)username password:(NSString*)password result:(void(^)(BOOL success))resultBlock
{
    [self validateTouchID:^(BOOL success) {
        if(success)
        {
            [Lockbox setString:username forKey:localUser];
            [Lockbox setString:password forKey:localPass];
        }
        
    }];
}

+(void)retrieveStoredCredentials:(void(^)(BOOL success, NSString* username, NSString* password))resultBlock
{
    [self validateTouchID:^(BOOL success) {
        NSString* localUserName;
        NSString* localPassword;
        if(success)
        {
            localUserName = [Lockbox stringForKey:localUser];
            localPassword = [Lockbox stringForKey:localPass];
        }
        resultBlock(success, localUserName, localPassword);
    }];
}


@end
