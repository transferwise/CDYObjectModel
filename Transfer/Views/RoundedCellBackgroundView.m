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
    [[UIColor controllerBackgroundColor] setFill];
    [path fill];
}

@end
