//
//  MixpanelIdentityHelper.h
//  Transfer
//
//  Created by Juhan Hion on 15.06.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixpanelIdentityHelper : NSObject

+ (void)handleRegistration:(NSString *)userId;
+ (void)handleLogin:(NSString *)userId;
+ (void)handleLogout;

@end
