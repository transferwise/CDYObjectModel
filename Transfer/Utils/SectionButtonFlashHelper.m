//
//  SendButtonFlashHelper.m
//  Transfer
//
//  Created by Mats Trovik on 08/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SectionButtonFlashHelper.h"
#import "Constants.h"

#define numberOfTimesToFlashInvites 3

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

+(void)flashInviteSectionIfNeeded
{
    NSInteger inviteFlashingHasBeenShown = [[NSUserDefaults standardUserDefaults] integerForKey:TRWDidHighlightInviteSection];
    if((inviteFlashingHasBeenShown >= 0 && inviteFlashingHasBeenShown <= numberOfTimesToFlashInvites))
    {
        inviteFlashingHasBeenShown++;
        [[NSUserDefaults standardUserDefaults] setInteger:inviteFlashingHasBeenShown forKey:TRWDidHighlightInviteSection];
        [self setInviteFlash:YES];
    }
}

+(void)inviteScreenHasBeenVisited
{
    NSInteger inviteFlashingHasBeenShown = [[NSUserDefaults standardUserDefaults] integerForKey:TRWDidHighlightInviteSection];
    if((inviteFlashingHasBeenShown > 0))
    {
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:TRWDidHighlightInviteSection];
    }
}

@end
