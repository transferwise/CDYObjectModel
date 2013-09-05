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

@interface FeedbackCoordinator () <UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger rateButtonIndex;
@property (nonatomic, assign) NSInteger feedbackButtonIndex;
@property (nonatomic, assign) NSInteger dismissButtonIndex;

@end

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
    [alertView setDelegate:self];
    [self setRateButtonIndex:[alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.rate", nil)]];
    [self setFeedbackButtonIndex:[alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.send.feedback", nil)]];
    [self setFeedbackButtonIndex:[alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.send.dismiss", nil)]];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.feedbackButtonIndex == buttonIndex) {
        return;
    }

    if (self.rateButtonIndex == buttonIndex) {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";

        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", TransferwiseAppID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }
}

@end
