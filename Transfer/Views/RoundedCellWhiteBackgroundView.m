//
//  RoundedCellWhiteBackgroundView.m
//  Transfer
//
//  Created by Henri Mägi on 20.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RoundedCellWhiteBackgroundView.h"

@implementation RoundedCellWhiteBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.roundedCorner cornerRadii:CGSizeMake(8, 8)];
    [[UIColor whiteColor] setFill];
    [path fill];
}

@end
