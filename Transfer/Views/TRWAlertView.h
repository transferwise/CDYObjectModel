//
//  TRWAlertView.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TRWAlertView : UIAlertView

@property (nonatomic, copy) TRWActionBlock leftButtonAction;

- (void)setConfirmButtonTitle:(NSString *)title;
- (void)setLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

+ (TRWAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (TRWAlertView *)errorAlertWithTitle:(NSString *)errorTitle error:(NSError *)error;

@end
