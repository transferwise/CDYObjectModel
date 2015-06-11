//
//  CustomInfoViewController+Notifications.h
//  Transfer
//
//  Created by Mats Trovik on 15/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"

@class ObjectModel;

@interface CustomInfoViewController (Notifications)

+(instancetype)notificationsCustomInfoWithName:(NSString*)recipientName
								   objectModel:(ObjectModel*)objectModel;

@end
