//
//  RoundedCellBackgroundView.m
//  Transfer
//
//  Created by Jaanus Siim on 6/10/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RoundedCellBackgroundView.h"
#import "UIColor+Theme.h"

@implementation RoundedCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setOpaque:NO];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.roundedCorner cornerRadii:CGSizeMake(8, 8)];

    if (!self.fillGradient) {
        [[UIColor controllerBackgroundColor] setFill];
        [path fill];
    } else {
        [path addClip];

        CGFloat colors [] = {
                230/255.0, 230/255.0, 230/255.0, 1.0,
                228/250.0, 228/250.0, 228/250.0, 1.0
        };

        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSaveGState(context);

        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;

        CGContextRestoreGState(context);
    }
}

@end
