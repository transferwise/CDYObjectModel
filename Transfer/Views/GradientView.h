//
//  GradientView.h
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, GradientOrientation)
{
    OrientationHorizontal = 0,
    OrientationVertical
};

@interface GradientView : UIView

@property (nonatomic, strong)UIColor *toColor;
@property (nonatomic, strong)UIColor *fromColor;

@property (nonatomic, assign)enum GradientOrientation orientation;

@end
