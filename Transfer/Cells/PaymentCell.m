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

@interface PaymentCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) TRWActionBlock cancelShownBlock;
@property (strong, nonatomic) TRWActionBlock cancelHiddenBlock;
@property (strong, nonatomic) TRWActionBlock cancelTappedBlock;
@property (nonatomic) BOOL canBeCancelled;
@property (nonatomic) BOOL isCancelShown;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation PaymentCell

- (void)configureWithPayment:(Payment *)payment
			cancelShownBlock:(TRWActionBlock)cancelShownBlock
		   cancelHiddenBlock:(TRWActionBlock)cancelHiddenBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock
{
	self.cancelButtonLeft.constant = 0;
	[self layoutIfNeeded];
	
	self.cancelShownBlock = cancelShownBlock;
	self.cancelHiddenBlock = cancelHiddenBlock;
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
    self.contentView.bgStyle=selected?@"cellSelected":@"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.bgStyle=highlighted?@"cellSelected":@"white";
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
	if(self.canBeCancelled)
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
			break;
		case UIGestureRecognizerStateChanged:
			//add the delta to button constraint (this works for both directions)
			self.cancelButtonLeft.constant = self.touchStart.x - currentPosition.x;
			NSLog(@"%f", self.cancelButtonLeft.constant);
			break;
		case UIGestureRecognizerStateEnded:
			//if button has been swiped wisible the whole width treat it as shown
			if(self.cancelButtonLeft.constant >= self.cancelButton.frame.size.width)
			{
				[self.moneyLabel setHidden:YES];
				[self.currencyLabel setHidden:YES];
				self.cancelShownBlock();
			}
			//else the button has either been swiped to hidden
			//or it has not been swiped out completely
			else
			{
				[self hideCancelButton:YES];
				self.cancelHiddenBlock();
			}
			break;
		default:
			self.touchStart = CGPointZero;
			break;
	}
}

- (void)hideCancelButton:(BOOL)animated
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
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
