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
    NSString *errorMessage = [error isTransferwiseError] ? [error localizedTransferwiseMessage] : [error localizedDescription];
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:errorTitle message:errorMessage];
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
    MCLog(@"alertView:didDismissWithButtonIndex:%d", buttonIndex);
    if (buttonIndex == self.leftButtonIndex && self.leftButtonAction) {
        self.leftButtonAction();
    }
}

@end
