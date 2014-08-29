//
//  SupportCoordinator.m
//  Transfer
//
//  Created by Jaanus Siim on 9/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SupportCoordinator.h"
#import "Constants.h"
#import "TRWAlertView.h"
#import "ObjectModel.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "UIDevice-Hardware.h"
#import "GoogleAnalytics.h"
#import "NavigationBarCustomiser.h"

@interface SupportCoordinator () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) NSInteger writeButtonIndex;
@property (nonatomic, assign) NSInteger callButtonIndex;
@property (nonatomic, weak) UIViewController *presentedOnController;
@property (nonatomic, copy) NSString *emailSubject;

@end

@implementation SupportCoordinator

+ (SupportCoordinator *)sharedInstance {
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

- (void)presentOnController:(UIViewController *)controller {
    [self presentOnController:controller emailSubject:nil];
}

- (void)presentOnController:(UIViewController *)controller emailSubject:(NSString *)emailSubject {
	[[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport"];
    [self setPresentedOnController:controller];
    [self setEmailSubject:emailSubject];

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"support.sheet.title", nil)
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	[self setWriteButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"support.sheet.write.message", nil)]];
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
	{
		[self setCallButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"support.sheet.call", nil)]];
	}
	NSInteger cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"button.title.cancel", nil)];
	[actionSheet setCancelButtonIndex:cancelButtonIndex];
	
	[actionSheet showInView:controller.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    MCLog(@"clickedButtonAtIndex:%d", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        MCLog(@"Cancel pressed");
        return;
    }
    
    if (buttonIndex == self.callButtonIndex) {
        MCLog(@"Call pressed");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", TRWSupportCallNumber]]];
    }

    if (buttonIndex != self.writeButtonIndex) {
        return;
    }

    MCLog(@"Send mail pressed");

    if (![MFMailComposeViewController canSendMail]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.cant.send.email.title", nil)
                                                           message:NSLocalizedString(@"support.cant.send.email.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    [NavigationBarCustomiser noStyling];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    [controller setToRecipients:@[[NSString stringWithFormat:@"%@ <%@>", NSLocalizedString(@"support.email.to.name", nil), TRWSupportEmail]]];
    [controller setSubject:self.emailSubject ? self.emailSubject : NSLocalizedString(@"support.generic.email.subject", nil)];
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"support.email.message.body.base", nil),
                                                       [NSString stringWithFormat:@"https://transferwise.com/admin/search?q=%@", [self.objectModel.currentUser email]], // link to profile
                                                       [[self.objectModel currentUser] displayName],
                                                       [[UIDevice currentDevice] platformString],
                                                       [[UIDevice currentDevice] systemVersion],
                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
    ];
    [controller setMessageBody:messageBody isHTML:YES];
    [self.presentedOnController presentViewController:controller animated:YES completion:^{
		if (IOS_7) {
			[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
		}
	}];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.send.email.error.title", nil)
                                                           message:NSLocalizedString(@"support.send.email.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
    
    [NavigationBarCustomiser setDefault];
    [self.presentedOnController dismissViewControllerAnimated:YES completion:nil];
}

@end
