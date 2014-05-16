//
//  TRWProgressHUD.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TRWProgressHUD.h"

@interface TRWProgressHUD ()
@end

@implementation TRWProgressHUD

+ (TRWProgressHUD *)showHUDOnView:(UIView *)view {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDAddedTo:view animated:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    return hud;
}

- (void)hide {
    [self hide:YES];
}

- (void)setMessage:(NSString *)message {
    [self setLabelText:message];
}


@end
