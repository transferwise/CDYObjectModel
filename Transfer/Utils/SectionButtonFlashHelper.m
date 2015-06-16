//
//  SendButtonFlashHelper.m
//  Transfer
//
//  Created by Mats Trovik on 08/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SectionButtonFlashHelper.h"

NSString *const TRWChangeSectionButtonFlashStatusNotification = @"TRWChangeSectionButtonFlashStatusNotification";
NSString *const TRWChangeSendButtonFlashOnOffKey = @"TRWChangeSendButtonFlashOnOffKey";
NSString *const TRWChangeInviteButtonFlashOnOffKey = @"TRWChangeInviteButtonFlashOnOffKey";

@implementation SectionButtonFlashHelper

+(void)setSendFlash:(BOOL)on
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWChangeSectionButtonFlashStatusNotification object:nil userInfo:@{TRWChangeSendButtonFlashOnOffKey:@(on)}];
}

+(void)setInviteFlash:(BOOL)on
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWChangeSectionButtonFlashStatusNotification object:nil userInfo:@{TRWChangeInviteButtonFlashOnOffKey:@(on)}];
}

@end
