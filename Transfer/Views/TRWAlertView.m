//
//  TRWAlertView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TRWAlertView.h"

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

@end
