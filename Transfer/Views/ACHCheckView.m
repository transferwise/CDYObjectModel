//
//  ACHCheckView.m
//  Transfer
//
//  Created by Mats Trovik on 20/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ACHCheckView.h"
#import "MOMStyle.h"
#import "Constants.h"

#define xOffset (IPAD ? 0.0f : 70.0f)
#define yOffset (IPAD ? -220.0f : -140.0f)
#define rotationAngle (M_PI_4/3.0f)
#define magnifyingScale (IPAD ? 1.0f : 1.5f)
#define animationDuration 0.5f
#define animationSpring 0.65f


@interface ACHCheckView ()
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIView *checkContainer;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UILabel *routingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (nonatomic, assign) ACHCheckViewState state;
@property (nonatomic, assign) BOOL isPanning;
@property (nonatomic, weak) UIPanGestureRecognizer* panRecognizer;
@property (nonatomic, assign) CGFloat panProgress;

@end

@implementation ACHCheckView

-(void)awakeFromNib
{
    self.routingNumberLabel.layer.allowsEdgeAntialiasing = YES;
    self.accountNumberLabel.layer.allowsEdgeAntialiasing = YES;
    self.routingNumberLabel.alpha = 1.0f;
    self.accountNumberLabel.alpha = 0.0f;
    [self updateContextLabel];
}



-(void)setState:(ACHCheckViewState)state animated:(BOOL)shouldAnimate
{
    [self setStateWithAnimation:state duration:shouldAnimate?animationDuration:0.0f force:NO];
}

-(void)setStateWithAnimation:(ACHCheckViewState)state duration:(NSTimeInterval)duration force:(BOOL)force
{
    BOOL shouldAnimate = duration > 0;
    if(!force && state == self.state)
    {
        return;
    }
    
    self.state = state;
    void(^layoutblock)(ACHCheckViewState state) = ^void(ACHCheckViewState state){
        switch (state) {
            case CheckStateRoutingHighlighted:
                [self styleForRoutingHighlighted];
                break;
            case CheckStateAccountHighlighted:
                [self styleForAccountHighlighted];
                break;
            case CheckStatePlain:
            default:
                [self styleForNormalState];
                [self updateContextLabel];
                break;
        }
    };
    self.autoresizingMask = UIViewAutoresizingNone;
    
    [self addToActiveView];
    
    if(shouldAnimate)
    {
        [UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:animationSpring initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            layoutblock(state);
        } completion:^(BOOL finished) {
            if(finished)
            {
                if(state == CheckStatePlain)
                {
                    
                    self.userInteractionEnabled = NO;
                    [self addToInactiveView];
                }
                else
                {
                    //set the frame again to avoid conflicts from additive animation.
                    [self addToActiveView];
                    self.userInteractionEnabled = YES;

                }
            }
        }];
    }
    else
    {
        layoutblock(state);
        if(state == CheckStatePlain)
        {
            [self addToInactiveView];
        }
    }
}

-(void) setActiveHostView:(UIView *)activeHostView
{
    if(self.panRecognizer)
    {
        [_activeHostView removeGestureRecognizer:self.panRecognizer];
    }
    _activeHostView = activeHostView;
    
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [activeHostView addGestureRecognizer:panGestureRecognizer];
    self.panRecognizer = panGestureRecognizer;
}

-(void)styleForNormalState
{
    self.checkContainer.transform = CGAffineTransformIdentity;
    
    self.contextLabel.alpha = 1.0f;
}

-(void)styleForRoutingHighlighted
{
    [self applySelectionTransform];
    
    self.contextLabel.alpha = 0.0f;
    
    self.routingNumberLabel.alpha = 1.0f;
    self.accountNumberLabel.alpha = 0.0f;
}

-(void)styleForAccountHighlighted
{
    [self applySelectionTransform];
    
    self.contextLabel.alpha = 0.0f;
    
    self.routingNumberLabel.alpha = 0.0f;
    self.accountNumberLabel.alpha = 1.0f;
}

-(void)applySelectionTransform
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
    CGPoint activeOffset = [self.activeHostView convertPoint:CGPointZero fromView:self.inactiveHostView];
    transform = CGAffineTransformTranslate(transform, xOffset, yOffset - activeOffset.y);
    transform = CGAffineTransformScale(transform, magnifyingScale, magnifyingScale);
    self.checkContainer.transform = transform;
}

-(void)addToActiveView
{
    CGRect newFrame = self.frame;
    CGPoint activeOffset = [self.activeHostView convertPoint:CGPointZero fromView:self.inactiveHostView];
    newFrame.origin = activeOffset;
    self.frame = newFrame;
    [self.activeHostView addSubview:self];
    self.userInteractionEnabled = YES;
    
}

-(void)addToInactiveView
{
    CGRect plainFrame = self.frame;
    plainFrame.origin = CGPointZero;
    self.frame = plainFrame;
    [self.inactiveHostView addSubview:self];
    self.userInteractionEnabled = NO;
}

- (IBAction)dismiss:(id)sender {
    [self.superview endEditing:YES];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //Only trap touch events that happen on the dismiss buttons. Let everything else through.
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            if([view pointInside:[self convertPoint:point toView:view] withEvent:event])
            {
                return YES;
            }
        }
    }
    return NO;
}

-(void)updateContextLabel
{
    NSString *labelIdentifier = NSLocalizedString([self currentlyHighlightedLabel]==self.accountNumberLabel?@"ach.controller.checkbook.account":@"ach.controller.checkbook.routing",nil);
    NSString *fullMessage = [NSString stringWithFormat:NSLocalizedString(@"ach.controller.checkbook", nil),labelIdentifier];
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:fullMessage];
    NSRange fullRange = NSMakeRange(0, [fullMessage length]);
    NSRange identifierRange = [fullMessage rangeOfString:labelIdentifier];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:fullRange];
    [attributedMessage addAttribute:NSFontAttributeName value:[UIFont fontFromStyle:self.contextLabel.fontStyle] range:fullRange];
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:self.contextLabel.fontStyle] range:fullRange];
    [attributedMessage addAttribute:NSFontAttributeName value:[UIFont fontFromStyle:self.contextLabel.selectedFontStyle] range:identifierRange];
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:self.contextLabel.selectedFontStyle] range:identifierRange];
    self.contextLabel.attributedText = attributedMessage;
}

-(UIView*)currentlyHighlightedLabel
{
    if(self.accountNumberLabel.alpha > 0)
    {
        return self.accountNumberLabel;
    }
    
    return self.routingNumberLabel;
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    float progress = 0;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            ;CGPoint startPoint = [recognizer locationInView:self];
            if(CGRectContainsPoint(self.bounds, startPoint))
            {
                self.isPanning = YES;
                [self addToActiveView];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if(self.isPanning)
            {
                CGPoint translation = [recognizer translationInView:self.inactiveHostView];
                if(self.state == CheckStatePlain)
                {
                    progress = MIN(MAX(0,translation.y/(yOffset)),1.0f);
                }
                else
                {
                    progress = 1.0f - MIN(MAX(0,-translation.y/(yOffset)),1.0f);
                }
                CGAffineTransform transform = CGAffineTransformMakeRotation(progress *rotationAngle);
                CGPoint activeOffset = [self.activeHostView convertPoint:CGPointZero fromView:self.inactiveHostView];
                transform = CGAffineTransformTranslate(transform, progress * (xOffset), progress * ((yOffset) - activeOffset.y));
                transform = CGAffineTransformScale(transform, 1.0 + progress * (magnifyingScale - 1), 1.0 + progress * (magnifyingScale - 1));
                self.checkContainer.transform = transform;
                self.contextLabel.alpha = MAX(0.0f,1-progress*10);
                
                self.panProgress = progress;
            }

            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if(self.isPanning)
            {
                ACHCheckViewState newState;
                progress = self.panProgress;
                CGPoint velocity = [recognizer velocityInView:self.inactiveHostView];
                if(ABS(velocity.y) > 150)
                {
                    //Moving fast
                    //Animate based on velocity
                    if (velocity.y > 0) {
                        NSTimeInterval duration = ABS(2* progress * (yOffset)/velocity.y);
                        newState = CheckStatePlain;
                        [self setStateWithAnimation:newState duration:duration force:YES];
                    }
                    else
                    {
                        NSTimeInterval duration = ABS(2* (1.0 - progress) * (yOffset)/velocity.y);
                        newState = self.state==CheckStatePlain?CheckStateRoutingHighlighted:self.state;
                        [self setStateWithAnimation:newState duration:duration force:YES];
                    }
                }
                else
                {
                    if(progress < 0.5)
                    {
                        newState = CheckStatePlain;
                        [self setStateWithAnimation:newState duration:animationDuration * progress force:YES];
                    }
                    else
                    {
                        newState = self.state==CheckStatePlain?CheckStateRoutingHighlighted:self.state;
                        [self setStateWithAnimation:newState duration:animationDuration * (1-progress) force:YES];
                    }
                }
                
                if([self.checkViewDelegate respondsToSelector:@selector(checkView:hasBeenDraggedtoState:)])
                {
                    [self.checkViewDelegate checkView:self hasBeenDraggedtoState:newState];
                }
                
                self.isPanning=NO;
            }
            else
            {
                if (self.state == CheckStatePlain)
                {
                    [self addToInactiveView];
                }
            }
        default:
            break;
    }
}

@end
