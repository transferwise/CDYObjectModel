//
//  SwipeToCancelCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SwipeToCancelCell.h"
#import "RedGradientButton.h"

#define SLOW_FLICK_VELOCITY	100
#define AUTO_ANIMATION_DURATION 0.3f

@interface SwipeToCancelCell ()

@property (strong, nonatomic) IBOutlet UIView *slidingContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewTrailing;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) TRWActionBlock willShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didHideCancelBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, assign) BOOL isCancelVisible;

@end

@implementation SwipeToCancelCell

#pragma mark - Init
- (void)prepareForReuse
{
	//reset for reuse
	self.isCancelVisible = NO;
	self.canBeCancelled = NO;
	self.touchStart = CGPointZero;
	self.contentViewTrailing.constant = 0;
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
	
	if(!self.panRecognizer)
	{
		self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		self.panRecognizer.delegate = self;
		[self addGestureRecognizer:self.panRecognizer];
	}
}

#pragma mark - Add swipe specific views/constraints
- (void)layoutSubviews
{
	[self setShadowView];
	[self setCancelButton];
	
	[super layoutSubviews];
}

- (void)setShadowView
{
	UIView* shadowView = [[UIView alloc] init];
	shadowView.translatesAutoresizingMaskIntoConstraints = NO;
	[shadowView setBackgroundColor:[UIColor blackColor]];
	[shadowView setAlpha:0.05f];
	[self.contentView addSubview:shadowView];
	
	NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:shadowView
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1.0f
															  constant:3.0f];
	NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:shadowView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:self.slidingContentView
															  attribute:NSLayoutAttributeHeight
															 multiplier:1.0f
															   constant:0.f];
	NSLayoutConstraint* horizontalPosition = [NSLayoutConstraint constraintWithItem:shadowView
																		  attribute:NSLayoutAttributeLeading
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.slidingContentView
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1.0f
																		   constant:0.f];
	NSLayoutConstraint* verticalPosition = [NSLayoutConstraint constraintWithItem:shadowView
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self.slidingContentView
																		attribute:NSLayoutAttributeTop
																	   multiplier:1.0f
																		 constant:0.f];
	[self.contentView addConstraints:@[width, height, horizontalPosition, verticalPosition]];
}

- (void)setCancelButton
{
	self.cancelButton = [[RedGradientButton alloc] init];
	self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
	
	if(self.cancelButtonTitle)
	{
		[self.cancelButton setTitle:self.cancelButtonTitle
						   forState:UIControlStateNormal];
	}
	else
	{
		[self.cancelButton setTitle:NSLocalizedString(@"button.title.cancel", nil)
						   forState:UIControlStateNormal];
	}
	[self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
	
	[self.cancelButton addTarget:self
						  action:@selector(cancelTapped:)
				forControlEvents:UIControlEventTouchUpInside];
	[self.contentView insertSubview:self.cancelButton belowSubview:self.slidingContentView];
	
	NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.cancelButton
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1.0f
															  constant:IPAD ? 120 : 90];
	NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:self.cancelButton
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:self.contentView
															  attribute:NSLayoutAttributeHeight
															 multiplier:1.0f
															   constant:0.f];
	NSLayoutConstraint* horizontalPosition = [NSLayoutConstraint constraintWithItem:self.cancelButton
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.contentView
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1.0f
																		   constant:0.f];
	NSLayoutConstraint* verticalPosition = [NSLayoutConstraint constraintWithItem:self.cancelButton
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self.contentView
																		attribute:NSLayoutAttributeTop
																	   multiplier:1.0f
																		 constant:0.f];
	[self.contentView addConstraints:@[width, height, horizontalPosition, verticalPosition]];
}

#pragma mark - Cancel button visiblity

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
    self.contentViewTrailing.constant = isCancelVisible ? self.cancelButton.bounds.size.width : 0.0f;
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
				self.contentViewTrailing.constant = dx;
			}
			if(dx < 0 && self.isCancelVisible)
			{
				//swiping to hide, add to button with and set to constraint
				self.contentViewTrailing.constant = self.cancelButton.frame.size.width + dx;
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
	if(self.contentViewTrailing.constant >= self.cancelButton.frame.size.width)
	{
		self.isCancelVisible = YES;
		[self didShow];
	}
	//if the button has been swiped hidden the whole width treat it as hidden
	else if(self.contentViewTrailing.constant <= 0)
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

- (void)cancelTapped:(id)sender
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

#pragma mark - Sliding Content Width Equal to superview
- (void)updateConstraints
{
	NSLayoutConstraint* c = [NSLayoutConstraint constraintWithItem:self.slidingContentView
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationEqual
															toItem:self.contentView
														 attribute:NSLayoutAttributeWidth
														multiplier:1.0f
														  constant:0.f];
	[self.contentView addConstraint:c];
	[super updateConstraints];
}
@end
