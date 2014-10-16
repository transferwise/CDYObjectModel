//
//  SendButtonFlashHelper.m
//  Transfer
//
//  Created by Mats Trovik on 08/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SendButtonFlashHelper.h"

NSString *const TRWChangeSendButtonFlashStatusNotification = @"TRWChangeSendButtonFlashStatusNotification";
NSString *const TRWChangeSendButtonFlashOnOffKey = @"TRWChangeSendButtonFlashOnOffKey";

@implementation SendButtonFlashHelper

+(void)setSendFlash:(BOOL)on
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWChangeSendButtonFlashStatusNotification object:nil userInfo:@{TRWChangeSendButtonFlashOnOffKey:@(on)}];
}

@end
