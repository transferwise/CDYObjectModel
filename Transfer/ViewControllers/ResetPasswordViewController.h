//
//  ResetPasswordViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DismissKeyboardViewController.h"

@protocol ResetPasswordViewControllerDelegate

- (void)resetEmailSent:(NSString *)email;

@end

@class ObjectModel;

@interface ResetPasswordViewController : DismissKeyboardViewController<UITextFieldDelegate>

@property (nonatomic, strong) ObjectModel* objectModel;
@property (weak, nonatomic) id<ResetPasswordViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isYahooReset;

@end
