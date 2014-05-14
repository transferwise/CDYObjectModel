//
//  TRWProgressHUD.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TRWProgressHUD.h"

@interface TRWProgressHUD ()
@property (nonatomic,strong)NSArray* viewsToDisable;
@end

@implementation TRWProgressHUD

+ (TRWProgressHUD *)showHUDOnView:(UIView *)view disableUserInteractionForViews:(NSArray*)viewsToDisable
{
    TRWProgressHUD* hud = [self showHUDOnView:view];
    hud.viewsToDisable = viewsToDisable;
    for(UIView* view in viewsToDisable)
    {
        view.userInteractionEnabled = NO;
    }
    return hud;
}

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

-(void)removeFromSuperview
{
    for(UIView* view in self.viewsToDisable)
    {
        view.userInteractionEnabled = YES;
    }
    [super removeFromSuperview];
}

@end
