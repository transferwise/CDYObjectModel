//
//  Constants.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Constants.h"

NSString *const TRWLoggedOutNotification = @"TRWLoggedOutNotification";
NSString *const TRWMoveToPaymentsListNotification = @"TRWMoveToPaymentsListNotification";

void delayedExecution(CGFloat seconds, TRWActionBlock action) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), action);
}
