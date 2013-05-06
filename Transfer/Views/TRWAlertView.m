//
//  TRWAlertView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"

@implementation TRWAlertView

+ (TRWAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    TRWAlertView *alertView = [[TRWAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    return alertView;
}

- (void)setConfirmButtonTitle:(NSString *)title {
    [self addButtonWithTitle:title];
}

+ (TRWAlertView *)errorAlertWithTitle:(NSString *)errorTitle error:(NSError *)error {
    NSString *errorMessage = [error isTransferwiseError] ? [error localizedTransferwiseMessage] : [error localizedFailureReason];
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:errorTitle message:errorMessage];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    return alertView;
}

@end
