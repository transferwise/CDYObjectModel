//
//  SpinningImageView.m
//  Transfer
//
//  Created by Jaanus Siim on 7/30/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SpinningImageView.h"
#import "Constants.h"

@interface SpinningImageView ()

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) BOOL animate;

@end

@implementation SpinningImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setAnimate:YES];
    [self rotate];
}

- (void)rotate {
    [self rotateByDegrees:2];
}

- (void)rotateByDegrees:(CGFloat)degrees {
    if (!self.animate) {
        return;
    }

    self.rotation += degrees;
    self.transform = CGAffineTransformMakeRotation(self.rotation * M_PI/180);

    [self performSelector:@selector(rotate) withObject:nil afterDelay:(1.0 / 60.0)];
}

- (void)stop {
    [self setAnimate:NO];
}

@end
