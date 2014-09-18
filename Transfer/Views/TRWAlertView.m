//
//  TRWAlertView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"

@interface TRWAlertView () <UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger leftButtonIndex;

@end

@implementation TRWAlertView

+ (TRWAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    TRWAlertView *alertView = [[TRWAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    [alertView setLeftButtonIndex:NSNotFound];
    [alertView setDelegate:alertView];
    return alertView;
}

+ (TRWAlertView *)errorAlertWithTitle:(NSString *)errorTitle error:(NSError *)error {
    TRWAlertView *alertView;
    if ([error isTransferwiseError]) {
        alertView = [TRWAlertView alertViewWithTitle:errorTitle message:[error localizedTransferwiseMessage]];
    } else {
        alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"generic.error.title", nil) message:NSLocalizedString(@"generic.error.message", nil)];
    }

    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    return alertView;
}

- (void)setConfirmButtonTitle:(NSString *)title {
    [self setConfirmButtonTitle:title action:nil];
}

- (void)setConfirmButtonTitle:(NSString *)title action:(TRWActionBlock)action {
    self.leftButtonIndex = [self addButtonWithTitle:title];
    self.leftButtonAction = action;
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
    self.leftButtonIndex = [self addButtonWithTitle:leftButtonTitle];
    [self addButtonWithTitle:rightButtonTitle];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    MCLog(@"alertView:didDismissWithButtonIndex:%ld", buttonIndex);
    if (buttonIndex == self.leftButtonIndex && self.leftButtonAction) {
        self.leftButtonAction();
    }
	else if(self.rightButtonAction)
	{
		self.rightButtonAction();
	}
}

@end
