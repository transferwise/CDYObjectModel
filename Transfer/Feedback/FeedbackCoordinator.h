//
//  FeedbackCoordinator.h
//  Transfer
//
//  Created by Jaanus Siim on 9/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackCoordinator : NSObject

+ (FeedbackCoordinator *)sharedInstance;

- (void)presentFeedbackAlert;

@end
