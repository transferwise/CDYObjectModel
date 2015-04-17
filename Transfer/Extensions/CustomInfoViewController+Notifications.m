//
//  CustomInfoViewController+Notifications.m
//  Transfer
//
//  Created by Mats Trovik on 15/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController+Notifications.h"
#import "Constants.h"

@implementation CustomInfoViewController (Notifications)

+(BOOL)shouldPresentNotificationsPrompt
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasDeclined = [defaults boolForKey:TRWDeclinedNotificationsSettingsKey];
    return !hasDeclined;
}

+(instancetype)notificationsCustomInfoWithName:(NSString*)recipientName
{
    CustomInfoViewController *result = [[CustomInfoViewController alloc] initWithNibName:@"CustomInfo_Notifications" bundle:nil];
    result.infoText = [NSString stringWithFormat:NSLocalizedString(@"notifications.info.format", nil),recipientName];
    result.titleText = @"";
    result.infoImage = [UIImage imageNamed:@"push_notification_icon"];
    result.actionButtonTitles = @[NSLocalizedString(@"notifications.yes", nil), NSLocalizedString(@"button.title.no", nil)];

    ActionButtonBlock yesBlock = ^{
        //TODO: add Notifications specific YES code here...
        [result dismiss];
    };
    ActionButtonBlock noBlock = ^{
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:TRWDeclinedNotificationsSettingsKey];
        [result dismiss];
    };

    result.actionButtonBlocks = @[yesBlock,noBlock];
    
    return result;
}


@end
