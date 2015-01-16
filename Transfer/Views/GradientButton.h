//
//  RedGradientButton.h
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoredButton.h"

@interface GradientButton : ColoredButton

@property (nonatomic,strong) UIColor *fromColor;
@property (nonatomic,strong) UIColor *toColor;

@end