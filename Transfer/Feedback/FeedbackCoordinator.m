//
//  FeedbackCoordinator.m
//  Transfer
//
//  Created by Jaanus Siim on 9/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "FeedbackCoordinator.h"
#import "Constants.h"
#import "TRWAlertView.h"

@implementation FeedbackCoordinator

+ (FeedbackCoordinator *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)initSingleton {
    self = [super init];
    if (self) {

    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

- (void)presentFeedbackAlert {
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"feedback.alert.title", nil)
                                                       message:NSLocalizedString(@"feedback.alert.message", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.rate", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.send.feedback", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.send.dismiss", nil)];
    [alertView show];
}

@end
