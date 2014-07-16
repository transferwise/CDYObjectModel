//
//  CancelHelper.m
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CancelHelper.h"
#import "Recipient.h"

@implementation CancelHelper

+ (void)cancelPayment:(Payment *)payment
		  cancelBlock:(TRWActionBlock)cancelBlock
	  dontCancelBlock:(TRWActionBlock)dontCancelBlock
{
	TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transactions.cancel.confirmation.title", nil)
													   message:[NSString stringWithFormat:NSLocalizedString(@"transactions.cancel.confirmation.message", nil), [payment.recipient name]]];
	[alertView setLeftButtonTitle:NSLocalizedString(@"button.title.yes", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];
	
	[alertView setLeftButtonAction:^{
		if(cancelBlock)
		{
			cancelBlock();
		}
		[self cancelPayment:payment];
	}];
	[alertView setRightButtonAction:^{
		if (dontCancelBlock)
		{
			dontCancelBlock();
		}
	}];
	
	[alertView show];
}

+ (void)cancelPayment:(Payment *)payment
{
	//TODO: implement payment cancelling when api supports it.
}

@end
