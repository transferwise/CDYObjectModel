//
//  TRWAlertView.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRWAlertView : UIAlertView

- (void)setConfirmButtonTitle:(NSString *)title;

+ (TRWAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (TRWAlertView *)errorAlertWithTitle:(NSString *)errorTitle error:(NSError *)error;

@end
