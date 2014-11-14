//
//  BottomButtonAnimator.m
//  Transfer
//
//  Created by Mats Trovik on 22/10/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CommonAnimationHelper.h"

#define offset 25.0f

@implementation CommonAnimationHelper


-(void)viewWillAppear:(BOOL)animated
{
    if(self.actionButtonBottomConstraint)
    {
        if(animated)
        {
            self.actionButtonBottomConstraint.constant = -offset;
            [self.actionButtonBottomConstraint.firstItem layoutIfNeeded];
            [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.actionButtonBottomConstraint.constant = 0.0f;
                [self.actionButtonBottomConstraint.firstItem layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.actionButtonBottomConstraint.constant = 0.0f;
                [self.actionButtonBottomConstraint.firstItem layoutIfNeeded];
            }
             ];
        }
    }
    else if(self.button)
    {
        if(animated)
        {
            CGRect originalFrame = self.button.frame;
            CGRect modifiedFrame = originalFrame;
            modifiedFrame.origin.y += offset;
            self.button.frame = modifiedFrame;
            [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.button.frame = originalFrame;
            } completion:nil];
        }
    }
}

@end
