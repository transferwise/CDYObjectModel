//
//  SwipeToCancelCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 08.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SwipeActionCell.h"
#import "GradientButton.h"

#define SLOW_FLICK_VELOCITY	100
#define AUTO_ANIMATION_DURATION 0.3f

@interface SwipeActionCell ()

@property (strong, nonatomic) IBOutlet UIView *slidingContentView;
@property (strong, nonatomic) NSLayoutConstraint *contentViewTrailing;
@property (strong, nonatomic) GradientButton *actionButton;
@property (strong, nonatomic) TRWActionBlock willShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didHideCancelBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIColor* fromColor;
@property (nonatomic, strong) UIColor* toColor;

@property (nonatomic, assign) BOOL isActionbuttonVisible;

@end

@implementation SwipeActionCell

#pragma mark - Init
- (void)awakeFromNib
{
	self.showFullWidth = YES;
}

- (void)prepareForReuse
{
	//reset for reuse
	self.isActionbuttonVisible = NO;
	self.canPerformAction = NO;
	self.touchStart = CGPointZero;
	if(self.contentViewTrailing)
	{
		self.contentViewTrailing.constant = 0;
	}
}

- (void)configureWithActionButtonFromColor:(UIColor*)fromColor
                               toColor:(UIColor*)toColor
               willShowActionButtonBlock:(TRWActionBlock)willShowCancelBlock
                didShowActionButtonBlock:(TRWActionBlock)didShowCancelBlock
                didHideActionButtonBlock:(TRWActionBlock)didHideCancelBlock
                       actionTappedBlock:(TRWActionBlock)cancelTappedBlock;
{
	self.willShowCancelBlock = willShowCancelBlock;
	self.didShowCancelBlock = didShowCancelBlock;
	self.didHideCancelBlock = didHideCancelBlock;
	self.cancelTappedBlock = cancelTappedBlock;
    
    self.toColor = toColor;
    self.fromColor = fromColor;
    if(self.actionButton)
    {
        self.actionButton.toColor = toColor;
        self.actionButton.fromColor = fromColor;
    }
	
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
	[self setActionButton];
	
	[super layoutSubviews];
}

- (void)setShadowView
{
	if (!self.shadowView)
	{
		self.shadowView = [[UIView alloc] init];
		self.shadowView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.shadowView setBackgroundColor:[UIColor blackColor]];
		[self.shadowView setAlpha:0.1f];
		[self.contentView addSubview:self.shadowView];
		
		NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.shadowView
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1.0f
																  constant:3.0f];
		NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:self.shadowView
																  attribute:NSLayoutAttributeHeight
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.slidingContentView
																  attribute:NSLayoutAttributeHeight
																 multiplier:1.0f
																   constant:0.f];
		NSLayoutConstraint* horizontalPosition = [NSLayoutConstraint constraintWithItem:self.shadowView
																			  attribute:NSLayoutAttributeLeading
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:self.slidingContentView
																			  attribute:NSLayoutAttributeTrailing
																			 multiplier:1.0f
																			   constant:0.f];
		NSLayoutConstraint* verticalPosition = [NSLayoutConstraint constraintWithItem:self.shadowView
																			attribute:NSLayoutAttributeTop
																			relatedBy:NSLayoutRelationEqual
																			   toItem:self.slidingContentView
																			attribute:NSLayoutAttributeTop
																		   multiplier:1.0f
																			 constant:0.f];
		[self.contentView addConstraints:@[width, height, horizontalPosition, verticalPosition]];
	}
}

- (void)setActionButton
{
	if (!self.actionButton)
	{
		self.actionButton = [[GradientButton alloc] init];
		self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
		
		if(self.actionButtonTitle)
		{
			[self.actionButton setTitle:self.actionButtonTitle
							   forState:UIControlStateNormal];
		}
		else
		{
			[self.actionButton setTitle:NSLocalizedString(@"button.title.cancel", nil)
							   forState:UIControlStateNormal];
		}
		[self.actionButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
		
		[self.actionButton addTarget:self
							  action:@selector(cancelTapped:)
					forControlEvents:UIControlEventTouchUpInside];
		[self.contentView insertSubview:self.actionButton belowSubview:self.slidingContentView];
		
		NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.actionButton
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1.0f
																  constant:IPAD ? 120 : 90];
		NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:self.actionButton
																  attribute:NSLayoutAttributeHeight
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.contentView
																  attribute:NSLayoutAttributeHeight
																 multiplier:1.0f
																   constant:0.f];
		NSLayoutConstraint* horizontalPosition = [NSLayoutConstraint constraintWithItem:self.actionButton
																			  attribute:NSLayoutAttributeTrailing
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:self.contentView
																			  attribute:NSLayoutAttributeTrailing
																			 multiplier:1.0f
																			   constant:0.f];
		NSLayoutConstraint* verticalPosition = [NSLayoutConstraint constraintWithItem:self.actionButton
																			attribute:NSLayoutAttributeTop
																			relatedBy:NSLayoutRelationEqual
																			   toItem:self.contentView
																			attribute:NSLayoutAttributeTop
																		   multiplier:1.0f
																			 constant:0.f];
		[self.contentView addConstraints:@[width, height, horizontalPosition, verticalPosition]];
        
        self.actionButton.fromColor = self.fromColor;
        self.actionButton.toColor = self.toColor;
	}
}

#pragma mark - Cancel button visiblity

- (void)setIsActionButtonVisible:(BOOL)isActionButtonVisible animated:(BOOL)animated
{
    if (animated)
    {
        [self animateWithDuration:AUTO_ANIMATION_DURATION easeOutOnly:NO isShow:isActionButtonVisible];
    }
    else
    {
        self.isActionbuttonVisible = isActionButtonVisible;
    }
    
    if(isActionButtonVisible)
    {
        [self didShow];
    }
    else
    {
        [self didHide];
    }
}

- (void)setIsActionbuttonVisible:(BOOL)isCancelVisible
{
    if(_isActionbuttonVisible != isCancelVisible)
    {
        _isActionbuttonVisible = isCancelVisible;
        self.contentViewTrailing.constant = isCancelVisible ? self.actionButton.bounds.size.width : 0.0f;
        [self layoutIfNeeded];
    }
}

#pragma mark - pan + tap
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
	//all kinds of gesture recognizers can end up here, so check that we are dealing with pan
	if(self.canPerformAction && [gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]])
	{
		UIView *cell = [gestureRecognizer view];
		CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
		
		// Check for horizontal gesture
		if (fabs(translation.x) > fabs(translation.y))
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
			
			if(dx > 0 && !self.isActionbuttonVisible)
			{
				//swiping to show, simply set constraint
				self.contentViewTrailing.constant = dx;
			}
			if(dx < 0 && self.isActionbuttonVisible)
			{
				//swiping to hide, add to button with and set to constraint
				self.contentViewTrailing.constant = self.actionButton.frame.size.width + dx;
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
	if(self.contentViewTrailing.constant >= self.actionButton.frame.size.width)
	{
		self.isActionbuttonVisible = YES;
		[self didShow];
	}
	//if the button has been swiped hidden the whole width treat it as hidden
	else if(self.contentViewTrailing.constant <= 0)
	{
		self.isActionbuttonVisible = NO;
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
        
        if(fabs(velocity.x) > SLOW_FLICK_VELOCITY)
        {
            // Flick
            shouldShow = velocity.x < 0;
            duration = 1/fabs(velocity.x);
            easeOutOnly = YES;
        }
        else
        {
            //Too slow! Dismiss to left or right depending on offset
            if(fabsf(dx) > self.actionButton.frame.size.width / 2)
			{
				shouldShow = !self.isActionbuttonVisible;
            }
            else
            {
                shouldShow = self.isActionbuttonVisible;
            }
            
            duration = AUTO_ANIMATION_DURATION/self.actionButton.bounds.size.width;
            
            easeOutOnly = NO;
        }
        
        if(dx > 0 && !self.isActionbuttonVisible)
        {
            distanceLeft = shouldShow?self.actionButton.bounds.size.width - dx: dx;
            
        }
        else if(dx < 0 && self.isActionbuttonVisible)
        {
            distanceLeft = shouldShow?-dx:self.actionButton.bounds.size.width + dx;
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
    self.didHideCancelBlock();
}

-(void)didShow
{
    self.didShowCancelBlock();
}

#pragma mark - Animation helper
- (void)animateWithDuration:(NSTimeInterval)duration easeOutOnly:(BOOL)outOnly isShow:(BOOL)show
{
    [self.contentView layoutIfNeeded];
    
	[UIView animateWithDuration:duration delay:0.0f options:outOnly?UIViewAnimationOptionCurveEaseOut:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.isActionbuttonVisible = show;
        [self.contentView layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Sliding Content Width Equal to superview
- (void)updateConstraints
{
	[self setUpSlidingContentConstraints];
	[super updateConstraints];
}

- (void)setUpSlidingContentConstraints
{
	NSLayoutConstraint* equalWidths = [NSLayoutConstraint constraintWithItem:self.slidingContentView
																   attribute:NSLayoutAttributeWidth
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self.contentView
																   attribute:NSLayoutAttributeWidth
																  multiplier:1.f
																	constant:0.f];
	NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:self.contentView
																attribute:NSLayoutAttributeTrailing
																relatedBy:NSLayoutRelationGreaterThanOrEqual
																   toItem:self.slidingContentView
																attribute:NSLayoutAttributeTrailing
															   multiplier:1.f
																 constant:0.f];
	NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:self.slidingContentView
															   attribute:NSLayoutAttributeLeading
															   relatedBy:NSLayoutRelationLessThanOrEqual
																  toItem:self.contentView
															   attribute:NSLayoutAttributeLeading
															  multiplier:1.f
																constant:0.f];
	NSLayoutConstraint* leadingLowerLimit = [NSLayoutConstraint constraintWithItem:self.slidingContentView
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationGreaterThanOrEqual
																			toItem:self.contentView
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1.f
																		  constant:IPAD ? -120.f : -90.f];
	if (!self.contentViewTrailing)
	{
		self.contentViewTrailing = [NSLayoutConstraint constraintWithItem:self.contentView
																attribute:NSLayoutAttributeTrailing
																relatedBy:NSLayoutRelationEqual
																   toItem:self.slidingContentView
																attribute:NSLayoutAttributeTrailing
															   multiplier:1.f
																 constant:0.f];
		self.contentViewTrailing.priority = 1;
		[self.contentView addConstraint:self.contentViewTrailing];
	}
	
	[self.contentView addConstraints:@[equalWidths, trailing, leading, leadingLowerLimit]];
}

#pragma mark - action button title

-(void)setActionButtonTitle:(NSString *)actionButtonTitle
{
    _actionButtonTitle = actionButtonTitle;
    if(self.actionButton)
    {
        [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
    }

}

@end
