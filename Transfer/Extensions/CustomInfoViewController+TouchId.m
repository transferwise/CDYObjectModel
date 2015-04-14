//
//  CustomInfoViewController+TouchId.m
//  Transfer
//
//  Created by Mats Trovik on 14/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController+TouchId.h"
#import "GoogleAnalytics.h"
#import "TouchIDHelper.h"

@implementation CustomInfoViewController (TouchId)

+(instancetype)touchIdCustomInfoWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void(^)(void))completionBlock
{
    CustomInfoViewController *result = [[CustomInfoViewController alloc] initWithNibName:@"CustomInfo_TouchId" bundle:nil];
    result.infoText = NSLocalizedString(@"touchid.prompt.info", nil);
    result.titleText = NSLocalizedString(@"touchid.prompt.title", nil);
    result.infoImage = [UIImage imageNamed:@"touch_id_image"];
    result.actionButtonTitles = @[NSLocalizedString(@"button.title.yes", nil), NSLocalizedString(@"button.title.no", nil), [NSNull null]];
    ActionButtonBlock yesBlock = ^{
        [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidprompted withLabel:@"Accepted"];
        [TouchIDHelper storeCredentialsWithUsername:username password:password result:^(BOOL success) {
            if(success)
            {
                [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidsetup];
                [result dismiss];
                if(completionBlock)
                {
                    completionBlock();
                }
            }
        }];
    };
    ActionButtonBlock noBlock = ^{
        [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidprompted withLabel:@"Declined"];
        [TouchIDHelper blockStorageForUsername:username];
        [result dismiss];
        
        if(completionBlock)
        {
            completionBlock();
        }
    };
    ActionButtonBlock closeBlock = ^{
        
        [result dismiss];
        if(completionBlock)
        {
            completionBlock();
        }
    };

    result.actionButtonBlocks = @[yesBlock,noBlock,closeBlock];
    
    return result;
}


@end
