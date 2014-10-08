//
//  SendButtonFlashHelper.h
//  Transfer
//
//  Created by Mats Trovik on 08/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TRWChangeSendButtonFlashStatusNotification;
extern NSString *const TRWChangeSendButtonFlashOnOffKey;

@interface SendButtonFlashHelper : NSObject

+(void)setSendFlash:(BOOL)on;

@end
