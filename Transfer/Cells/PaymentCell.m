//
//  PaymentCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentCell.h"
#import "Payment.h"
#import "Recipient.h"
#import "MOMStyle.h"

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

@interface PaymentCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) TRWActionBlock willShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didShowCancelBlock;
@property (strong, nonatomic) TRWActionBlock didHideCancelBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) BOOL canBeCancelled;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, weak) UITableView* parent;

@end

@implementation PaymentCell

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

- (void)prepareForReuse
{
	//reset for reuse
	self.isCancelVisible = NO;
	self.canBeCancelled = NO;
	self.touchStart = CGPointZero;
	self.cancelButtonLeft.constant = 0;
	[self.moneyLabel setHidden:NO];
	[self.currencyLabel setHidden:NO];
}

- (void)configureWithPayment:(Payment *)payment
		 willShowCancelBlock:(TRWActionBlock)willShowCancelBlock
		  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
		  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock
					  parent:(UITableView *)parent;
{
	self.willShowCancelBlock = willShowCancelBlock;
	self.didShowCancelBlock = didShowCancelBlock;
	self.didHideCancelBlock = didHideCancelBlock;
	self.cancelTappedBlock = cancelTappedBlock;
	
	[self.cancelButton setTitle:NSLocalizedString(@"button.title.cancel", nil)
					   forState:UIControlStateNormal];
	
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.currencyLabel setText:[payment transferredCurrenciesString]];
    
    UIImage *icon;
    switch ([payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusMatched:
           icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canBeCancelled = YES;
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canBeCancelled = YES;
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canBeCancelled = YES;
            break;
        case PaymentStatusSubmitted:
        case PaymentStatusUserHasPaid:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canBeCancelled = YES;
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_icon_complete"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            self.canBeCancelled = NO;
            break;
    }
    
    self.statusIcon.image = icon;
    
    UIColor * conditionalColor;
    if(payment.isCancelled)
    {
        conditionalColor = [UIColor colorFromStyle:@"lightText"];
    }
    else
    {
        conditionalColor = [UIColor colorFromStyle:@"darkText"];
    }
    
    self.moneyLabel.textColor = conditionalColor;
    self.nameLabel.textColor = conditionalColor;
	
	if(!self.panRecognizer)
	{
		self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		self.panRecognizer.delegate = self;
		[self addGestureRecognizer:self.panRecognizer];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.contentView.bgStyle = selected ? @"cellSelected" : @"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.bgStyle = highlighted ? @"cellSelected" : @"white";
}

#pragma mark - Cancel button show/hide + tap
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
			//if button has been swiped wisible the whole width treat it as shown
			if(self.cancelButtonLeft.constant >= self.cancelButton.frame.size.width)
			{
				self.isCancelVisible = YES;
				self.didShowCancelBlock();
			}
			//else the button has either been swiped to hidden
			//or it has not been swiped out completely
			else
			{
				self.isCancelVisible = NO;
				self.didHideCancelBlock();
			}
			self.touchStart = CGPointZero;
			break;
		default:
			self.touchStart = CGPointZero;
			break;
	}
}

- (void)showCancelButton
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.2 animations:^{
		//low priority random high number will work
		self.cancelButtonLeft.constant = 1000;
		[self.moneyLabel setHidden:YES];
		[self.currencyLabel setHidden:YES];
		[self.contentView layoutIfNeeded];
	}];
}

- (void)hideCancelButton
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.2 animations:^{
		self.cancelButtonLeft.constant = 0;
		[self.moneyLabel setHidden:NO];
		[self.currencyLabel setHidden:NO];
		[self.contentView layoutIfNeeded];
	}];
}

- (IBAction)cancelTapped:(id)sender
{
	if (self.cancelTappedBlock != nil)
	{
		self.cancelTappedBlock();
	}
}

@end
