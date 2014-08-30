//
//  NavigationBarCustomiser.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NavigationBarCustomiser.h"
#import "MOMBasicStyle.h"
#import "MOMStyleFactory.h"
#import "UIColor+MOMStyle.h"
#import "UIImage+Color.h"
#import <MessageUI/MessageUI.h>

@implementation NavigationBarCustomiser

+ (void)setDefault
{
	[self applyDefault:[UINavigationBar appearance]];
}

+(void)applyDefault:(UINavigationBar*)navBar
{
    MOMBasicStyle* navFontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"heavy.@{18,20}.DarkFont"];
	[navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [navFontStyle color], NSFontAttributeName : [navFontStyle font]}];
	[navBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"LightBlue"]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
	[navBar setShadowImage:[[UIImage alloc] init]];
	[navBar setTitleVerticalPositionAdjustment:-2 forBarMetrics:UIBarMetricsDefault];
}

+ (void)setWhite
{
	[self applyWhite:[UINavigationBar appearance]];
}

+(void)applyWhite:(UINavigationBar*)navBar
{
    MOMBasicStyle* navFontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"heavy.@{18,20}.DarkFont"];
	[navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [navFontStyle color], NSFontAttributeName : [navFontStyle font]}];
	[navBar setBarTintColor:[UIColor colorFromStyle:@"white"]];
    [navBar setTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
	[navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
	[navBar setShadowImage:[[UIImage alloc] init]];
}


+ (void)setVerificationNeededStyle
{
	[self applyVerificationNeededStyle:[UINavigationBar appearance]];
}

+(void)applyVerificationNeededStyle:(UINavigationBar*)navBar
{
    MOMBasicStyle* navFontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"heavy.@{18,20}.white"];
	[navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [navFontStyle color], NSFontAttributeName : [navFontStyle font]}];
	[navBar setBarTintColor:[UIColor colorFromStyle:@"white"]];
    [navBar setTintColor:[UIColor colorFromStyle:@"white"]];
	[navBar setBackgroundImage:[UIImage imageNamed:@"verificationBackground"] forBarMetrics:UIBarMetricsDefault];
	[navBar setShadowImage:[[UIImage alloc] init]];
}

+ (void)noStyling
{
    [self removeStyling:[UINavigationBar appearance]];
}

+(void)removeStyling:(UINavigationBar*)navBar
{
    [navBar setTitleTextAttributes:@{}];
	[navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:nil];
	[navBar setShadowImage:nil];
	[navBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}
@end
