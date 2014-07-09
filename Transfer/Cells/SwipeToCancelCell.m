//
//  SwipeToCancelCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SwipeToCancelCell.h"

#define SLOW_FLICK_VELOCITY	100
#define AUTO_ANIMATION_DURATION 0.3f

@interface SwipeToCancelCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) TRWActionBlock willShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didHideCancelBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, assign) BOOL isCancelVisible;

@end

@implementation SwipeToCancelCell

- (void)prepareForReuse
{
	//reset for reuse
	self.isCancelVisible = NO;
	self.canBeCancelled = NO;
	self.touchStart = CGPointZero;
	self.cancelButtonLeft.constant = 0;
}

- (void)configureWithWillShowCancelBlock:(TRWActionBlock)willShowCancelBlock
					  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
					  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
					   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock
{
	self.willShowCancelBlock = willShowCancelBlock;
	self.didShowCancelBlock = didShowCancelBlock;
	self.didHideCancelBlock = didHideCancelBlock;
	self.cancelTappedBlock = cancelTappedBlock;
	
	[self.cancelButton setTitle:NSLocalizedString(@"button.title.cancel", nil)
					   forState:UIControlStateNormal];
	
	if(!self.panRecognizer)
	{
		self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		self.panRecognizer.delegate = self;
		[self addGestureRecognizer:self.panRecognizer];
	}
}

#pragma mark cancel button visiblity

- (void)setIsCancelVisible:(BOOL)isCancelVisible animated:(BOOL)animated
{
    if (animated)
    {
        [self animateWithDuration:AUTO_ANIMATION_DURATION easeOutOnly:NO isShow:isCancelVisible];
    }
    else
    {
        self.isCancelVisible = isCancelVisible;
    }
    
    if(isCancelVisible)
    {
        [self didShow];
    }
    else
    {
        [self didHide];
    }
    
}

- (void)setIsCancelVisible:(BOOL)isCancelVisible
{
	_isCancelVisible = isCancelVisible;
    self.cancelButtonLeft.constant = isCancelVisible?self.cancelButton.bounds.size.width:0.0f;
    [self layoutIfNeeded];
    
}

#pragma mark - pan + tap
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
	//all kinds of gesture recognizers can end up here, so check that we are dealing with pan
	if(self.canBeCancelled && [gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]])
	{
		UIView *cell = [gestureRecognizer view];
		CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
		
		// Check for horizontal gesture
		if (fabsf(translation.x) > fabsf(translation.y))
		{
			return YES;
		}
	}
	
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
	CGPoint currentPosition = [recognizer locationInView:self];
	switch (recognizer.state)
	{
		case UIGestureRecognizerStateBegan:
			//mark the start position
			self.touchStart = currentPosition;
			self.willShowCancelBlock();
			break;
		case UIGestureRecognizerStateChanged:
		{
			float dx = self.touchStart.x - currentPosition.x;
			
			if(dx > 0 && !self.isCancelVisible)
			{
				//swiping to show, simply set constraint
				self.cancelButtonLeft.constant = dx;
			}
			if(dx < 0 && self.isCancelVisible)
			{
				//swiping to hide, add to button with and set to constraint
				self.cancelButtonLeft.constant = self.cancelButton.frame.size.width + dx;
			}
		}
			break;
		case UIGestureRecognizerStateEnded:
			[self handleSwipeEnd:recognizer currentPosition:currentPosition];
			self.touchStart = CGPointZero;
			break;
		default:
			self.touchStart = CGPointZero;
			break;
	}
}

- (void)handleSwipeEnd:(UIPanGestureRecognizer *)recognizer currentPosition:(CGPoint)currentPosition
{
	//if button has been swiped visible the whole width treat it as shown
	if(self.cancelButtonLeft.constant >= self.cancelButton.frame.size.width)
	{
		self.isCancelVisible = YES;
		[self didShow];
	}
	//if the button has been swiped hidden the whole width treat it as hidden
	else if(self.cancelButtonLeft.constant <= 0)
	{
		self.isCancelVisible = NO;
		[self didHide];
	}
	//handle flick and half length swipes
	else
	{
		float dx = self.touchStart.x - currentPosition.x;
		CGPoint velocity = [recognizer velocityInView:self];
		
        BOOL shouldShow;
        CGFloat distanceLeft = 0.0f;
        BOOL easeOutOnly;
        NSTimeInterval duration = 0.0f;
        
        if(fabsf(velocity.x) > SLOW_FLICK_VELOCITY)
        {
            // Flick
            shouldShow = velocity.x < 0;
            duration = 1/fabsf(velocity.x);
            easeOutOnly = YES;
        }
        else
        {
            //Too slow! Dismiss to left or right depending on offset
            if(fabsf(dx) > self.cancelButton.frame.size.width / 2)
			{
				shouldShow = !self.isCancelVisible;
            }
            else
            {
                shouldShow = self.isCancelVisible;
            }
            
            duration = AUTO_ANIMATION_DURATION/self.cancelButton.bounds.size.width;
            
            easeOutOnly = NO;
        }
        
        if(dx > 0 && !self.isCancelVisible)
        {
            distanceLeft = shouldShow?self.cancelButton.bounds.size.width - dx: dx;
            
        }
        else if(dx < 0 && self.isCancelVisible)
        {
            distanceLeft = shouldShow?-dx:self.cancelButton.bounds.size.width + dx;
        }
        
        
        duration *= distanceLeft;

        
        [self animateWithDuration:duration easeOutOnly:easeOutOnly isShow:shouldShow];
        if(shouldShow)
        {
            [self didShow];
        }
        else
        {
            [self didHide];
        }
    }
}

- (IBAction)cancelTapped:(id)sender
{
	if (self.cancelTappedBlock != nil)
	{
		self.cancelTappedBlock();
	}
}

#pragma mark Hide/Show events

-(void)didHide
{
    [self showOnCancelHide];
    self.didHideCancelBlock();
}

-(void)didShow
{
    [self hideOnCancelShow];
    self.didShowCancelBlock();
}

- (void)hideOnCancelShow
{
	//override in subcalss to hide things that are behind cancel button
}

- (void)showOnCancelHide
{
	//override on subclass to show things that are behind cancel button
}

#pragma mark - Animation helper
- (void)animateWithDuration:(NSTimeInterval)duration easeOutOnly:(BOOL)outOnly isShow:(BOOL)show
{
    [self.contentView layoutIfNeeded];
    
	[UIView animateWithDuration:duration delay:0.0f options:outOnly?UIViewAnimationOptionCurveEaseOut:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.isCancelVisible = show;
        [self.contentView layoutIfNeeded];
    } completion:nil];
}

@end
