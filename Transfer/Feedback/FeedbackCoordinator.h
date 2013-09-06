//
//  FeedbackCoordinator.h
//  Transfer
//
//  Created by Jaanus Siim on 9/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

@interface FeedbackCoordinator : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

+ (FeedbackCoordinator *)sharedInstance;

- (void)presentFeedbackAlert;

@end
