//
//  MainViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class ObjectModel;

@interface MainViewController : UINavigationController

@property (nonatomic, strong) ObjectModel *objectModel;

- (BOOL)dispatchNotification:(NotificationToDispatch)notificationToDispatch
					  itemId:(NSNumber *)itemId;

@end
