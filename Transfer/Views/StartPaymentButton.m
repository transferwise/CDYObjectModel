//
//  StartPaymentButton.m
//  Transfer
//
//  Created by Jaanus Siim on 31/01/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "StartPaymentButton.h"
#import "NSString+Validation.h"

@interface StartPaymentButton ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSString *originalTitle;

@end

@implementation StartPaymentButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showCalculating:(BOOL)calculating {
    if (calculating) {
        [self setUserInteractionEnabled:NO];
        [self.activityIndicator startAnimating];
        [self setOriginalTitle:[self titleForState:UIControlStateNormal]];
        [self setTitle:NSLocalizedString(@"start.calculating.button.pending.message", nil) forState:UIControlStateNormal];
        CGRect indicatorFrame = self.activityIndicator.frame;
        indicatorFrame.origin.x = self.titleLabel.frame.origin.x - CGRectGetWidth(indicatorFrame) - 10;
        indicatorFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(indicatorFrame)) / 2;
        [self.activityIndicator setFrame:indicatorFrame];
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:0.5];
        }];
    } else if ([self.originalTitle hasValue]) {
        [self setUserInteractionEnabled:YES];
        [self setTitle:self.originalTitle forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:1];
        }];
        [self.activityIndicator stopAnimating];
    }
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator setHidesWhenStopped:YES];
        [self addSubview:_activityIndicator];
    }

    return _activityIndicator;
}


@end
