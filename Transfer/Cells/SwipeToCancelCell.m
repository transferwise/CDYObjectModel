//
//  SwipeToCancelCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SwipeToCancelCell.h"

#define FLICK_VELOCITY	700

@interface SwipeToCancelCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) TRWActionBlock willShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didHideCancelBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

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

- (void)setIsCancelVisible:(BOOL)isCancelVisible
{
	if (isCancelVisible)
	{
		[self showCancelButton];
	}
	else
	{
		[self hideCancelButton];
	}
	
	_isCancelVisible = isCancelVisible;
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
		self.didShowCancelBlock();
	}
	//if the button has been swiped hidden the whole width treat it as hidden
	else if(self.cancelButtonLeft.constant <= 0)
	{
		self.isCancelVisible = NO;
		self.didHideCancelBlock();
	}
	//handle flick and half length swipes
	else
	{
		float dx = self.touchStart.x - currentPosition.x;
		
		//if this is a half swipe finish it
		if (self.cancelButton.frame.size.width / 2 <= fabsf(dx))
		{
			[self showOrHideCancel:dx];
		}
		//if this is a flick finish it
		else if(fabsf([recognizer velocityInView:self].x) > FLICK_VELOCITY)
		{
			[self showOrHideCancel:dx];
		}
		//hopeless hide cancel
		else
		{
			self.isCancelVisible = NO;
			self.didHideCancelBlock();
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

#pragma mark - Show/Hide
- (void)showOrHideCancel:(float)dx
{
	if (dx > 0)
	{
		self.isCancelVisible = YES;
		self.didShowCancelBlock();
	}
	else
	{
		self.isCancelVisible = NO;
		self.didHideCancelBlock();
	}
}

- (void)showCancelButton
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.1 animations:^{
		//low priority constraint random high number will work
		self.cancelButtonLeft.constant = 1000;
		[self hideOnCancelShow];
		[self.contentView layoutIfNeeded];
	}];
}

- (void)hideCancelButton
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.1 animations:^{
		self.cancelButtonLeft.constant = 0;
		[self showOnCancelHide];
		[self.contentView layoutIfNeeded];
	}];
}

- (void)hideOnCancelShow
{
	//override in subcalss to hide things that are behind cancel button
}

- (void)showOnCancelHide
{
	//override on subclass to show things that are behind cancel button
}

@end
