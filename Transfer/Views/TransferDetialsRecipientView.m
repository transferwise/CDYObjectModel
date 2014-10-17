//
//  TransferDetialsRecipientView.m
//  Transfer
//
//  Created by Juhan Hion on 12.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetialsRecipientView.h"
#import "Payment.h"
#import "Recipient.h"
#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "Constants.h"

@interface TransferDetialsRecipientView ()

@property (strong, nonatomic) IBOutlet UILabel *accountHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation TransferDetialsRecipientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithPayment:(Payment *)payment
{
	[self.accountHeaderLabel setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.account.to", nil), [payment.recipient name]]];
    NSString* email =(payment.status == PaymentStatusCancelled||payment.status == PaymentStatusRefunded)?nil:[payment.recipient email];
	
	if (email.length > 0)
	{
		[self.detailsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.account.sent", nil), [payment.recipient presentationStringFromAllValues], [payment.recipient name], [payment.recipient email]]];
	}
	else
	{
		[self.detailsLabel setText:[payment.recipient presentationStringFromAllValues]];
	}
}

@end
