//
//  ACHCheckView.m
//  Transfer
//
//  Created by Mats Trovik on 20/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ACHCheckView.h"
#import "MOMStyle.h"

#define xOffset 70.0f
#define yOffset -140.0
#define rotationAngle M_PI_4/3.0f
#define magnifyingScale 1.5f
#define animationDuration 0.3f


@interface ACHCheckView ()
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIView *checkContainer;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UILabel *routingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;

@end

@implementation ACHCheckView


-(void)setState:(ACHCheckViewState)state animated:(BOOL)shouldAnimate
{
    void(^layoutblock)(ACHCheckViewState state) = ^void(ACHCheckViewState state){
        switch (state) {
            case CheckStateRoutingHighlighted:
                [self layoutRouting];
                break;
            case CheckStateAccountHighlighted:
                [self layoutAccount];
                break;
            case CheckStatePlain:
            default:
                [self layoutNormal];
                break;
        }
    };
    [self.activeHostView addSubview:self];
    if(shouldAnimate)
    {
        [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            layoutblock(state);
        } completion:^(BOOL finished) {
            if(state == CheckStatePlain)
            {
                [self.inactiveHostView addSubview:self];
            }
        }];
    }
    else
    {
        layoutblock(state);
        if(state == CheckStatePlain)
        {
            [self.inactiveHostView addSubview:self];
        }
    }
}

-(void)layoutNormal
{
    self.checkContainer.transform = CGAffineTransformIdentity;
    
    self.contextLabel.alpha = 1.0f;
    
    self.routingNumberLabel.alpha = 0.0f;
    self.accountNumberLabel.alpha = 0.0f;
}

-(void)layoutRouting
{
    [self applySelectionTransform];
    
    self.contextLabel.alpha = 0.0f;
    
    self.routingNumberLabel.alpha = 1.0f;
    self.accountNumberLabel.alpha = 0.0f;
}

-(void)layoutAccount
{
    [self applySelectionTransform];
    
    self.contextLabel.alpha = 0.0f;
    
    self.routingNumberLabel.alpha = 0.0f;
    self.accountNumberLabel.alpha = 1.0f;
}

-(void)applySelectionTransform
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
    transform = CGAffineTransformTranslate(transform, xOffset, yOffset);
    transform = CGAffineTransformScale(transform, magnifyingScale, magnifyingScale);
    self.checkContainer.transform = transform;
}

@end
