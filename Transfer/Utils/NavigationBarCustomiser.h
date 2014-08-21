//
//  NavigationBarCustomiser.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationBarCustomiser : NSObject

+ (void)setDefault;
+ (void)applyDefault:(UINavigationBar*)navBar;

+ (void)setWhite;
+ (void)applyWhite:(UINavigationBar*)navBar;


+ (void)setVerificationNeededStyle;
+ (void)applyVerificationNeededStyle:(UINavigationBar*)navBar;

+ (void)noStyling;
+ (void)removeStyling:(UINavigationBar*)navBar;


@end
