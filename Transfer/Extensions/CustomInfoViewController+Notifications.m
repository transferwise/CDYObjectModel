//
//  CustomInfoViewController+Notifications.m
//  Transfer
//
//  Created by Mats Trovik on 15/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController+Notifications.h"
#import "PushNotificationsHelper.h"
#import "Constants.h"
#import "ObjectModel.h"

@implementation CustomInfoViewController (Notifications)

+(instancetype)notificationsCustomInfoWithName:(NSString*)recipientName objectModel:(ObjectModel*)objectModel
{
    CustomInfoViewController *result = [[CustomInfoViewController alloc] initWithNibName:@"CustomInfo_Notifications" bundle:nil];
    result.infoText = [NSString stringWithFormat:NSLocalizedString(@"notifications.info.format", nil),recipientName];
    result.titleText = @"";
    result.infoImage = [UIImage imageNamed:@"push_notification_icon"];
    result.actionButtonTitles = @[NSLocalizedString(@"notifications.yes", nil), NSLocalizedString(@"button.title.no", nil)];

    ActionButtonBlock yesBlock = ^{
        PushNotificationsHelper *helper = [PushNotificationsHelper sharedInstanceWithApplication:[UIApplication sharedApplication] objectModel:objectModel];
        [helper registerForPushNotifications:NO];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:TRWHasRespondedToNotificationsPromptSettingsKey];
        [result dismiss];
    };
    ActionButtonBlock noBlock = ^{
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:TRWHasRespondedToNotificationsPromptSettingsKey];
        [result dismiss];
    };

    result.actionButtonBlocks = @[yesBlock,noBlock];
    
    return result;
}


@end
