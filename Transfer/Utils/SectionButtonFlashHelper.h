//
//  SendButtonFlashHelper.h
//  Transfer
//
//  Created by Mats Trovik on 08/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TRWChangeSectionButtonFlashStatusNotification;
extern NSString *const TRWChangeSendButtonFlashOnOffKey;
extern NSString *const TRWChangeInviteButtonFlashOnOffKey;

@interface SectionButtonFlashHelper : NSObject

+(void)setSendFlash:(BOOL)on;
+(void)setInviteFlash:(BOOL)on;
+(void)flashInviteSectionIfNeeded;
+(void)inviteScreenHasBeenVisited;

@end
