//
//  FeedbackCoordinator.h
//  Transfer
//
//  Created by Jaanus Siim on 9/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

typedef BOOL (^FeedbackCheckBlock)();

@interface FeedbackCoordinator : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

+ (FeedbackCoordinator *)sharedInstance;

- (void)presentFeedbackAlert;
- (void)presentFeedbackEmail;
- (void)startFeedbackTimerWithCheck:(FeedbackCheckBlock)checkBlock;

@end
