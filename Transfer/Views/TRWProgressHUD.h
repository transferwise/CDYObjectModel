//
//  TRWProgressHUD.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MBProgressHUD.h"

@interface TRWProgressHUD : MBProgressHUD

+ (TRWProgressHUD *)showHUDOnView:(UIView *)view;
- (void)hide;
- (void)setMessage:(NSString *)message;


@end
