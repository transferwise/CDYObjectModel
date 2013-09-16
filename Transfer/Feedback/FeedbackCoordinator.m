//
//  FeedbackCoordinator.m
//  Transfer
//
//  Created by Jaanus Siim on 9/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "FeedbackCoordinator.h"
#import "Constants.h"
#import "TRWAlertView.h"
#import "UIDevice-Hardware.h"
#import "ObjectModel+Users.h"
#import "User.h"

@interface FeedbackCoordinator () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

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
    [self setDismissButtonIndex:[alertView addButtonWithTitle:NSLocalizedString(@"feedback.alert.button.send.dismiss", nil)]];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.rateButtonIndex == buttonIndex) {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";

        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", TransferwiseAppID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }

    if (self.feedbackButtonIndex != buttonIndex) {
        return;
    }

    MCLog(@"Send mail pressed");

	[self presentFeedbackEmail];
}

- (void)presentFeedbackEmail {
	if (![MFMailComposeViewController canSendMail]) {
		TRWAlertView *alert = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.cant.send.email.title", nil)
													   message:NSLocalizedString(@"support.cant.send.email.message", nil)];
		[alert setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
		[alert show];
		return;
	}

	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	[controller setMailComposeDelegate:self];
	[controller setToRecipients:@[TRWFeedbackEmail]];
	[controller setSubject:NSLocalizedString(@"feedback.email.subject", nil)];
	NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"feedback.email.message.body.base", nil),
													   [NSString stringWithFormat:@"https://transferwise.com/admin/search?q=%@", [self.objectModel.currentUser email]], // link to profile
													   [[self.objectModel currentUser] displayName],
													   [[UIDevice currentDevice] platformString],
													   [[UIDevice currentDevice] systemVersion],
													   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
	];

	[controller setMessageBody:messageBody isHTML:YES];

	[[FeedbackCoordinator rootViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.send.email.error.title", nil)
                                                           message:NSLocalizedString(@"support.send.email.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

+ (id)rootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }

    for (UIView *subView in [window subviews]) {
        UIResponder *responder = [subView nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewController:(UIViewController *) responder];
        }
    }

    return nil;
}

+ (UIViewController *)topMostViewController:(UIViewController *)controller {
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if (presented != nil) {
            controller = presented;
        }

    } while (isPresenting);

    return controller;
}

@end
