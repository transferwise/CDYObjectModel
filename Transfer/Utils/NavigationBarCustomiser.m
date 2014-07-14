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

@implementation NavigationBarCustomiser

+ (void)setDefault
{
	MOMBasicStyle* navFontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"light.@{18,19}.CoreFont"];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [navFontStyle color], NSFontAttributeName : [navFontStyle font]}];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"LightBlue"]] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-2 forBarMetrics:UIBarMetricsDefault];
}

+ (void)setWhite
{
	MOMBasicStyle* navFontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@{18,19}.CoreFont"];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [navFontStyle color], NSFontAttributeName : [navFontStyle font]}];
	[[UINavigationBar appearance] setBarTintColor:[UIColor colorFromStyle:@"white"]];
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
