//
//  TransferDetialsRecipientView.m
//  Transfer
//
//  Created by Juhan Hion on 12.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetialsRecipientView.h"
#import "Recipient.h"
#import "TypeFieldValue.h"
#import "RecipientTypeField.h"

@interface TransferDetialsRecipientView ()

@property (strong, nonatomic) IBOutlet UILabel* accountHeaderLabel;

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

- (void)configureWithRecipient:(Recipient *)recipient
{
	[self.accountHeaderLabel setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.account.details", nil), [recipient name]]];
	
	for (TypeFieldValue *value in recipient.fieldValues) {
        NSLog(@"%@ %@",value.valueForField.title, value.presentedValue);
    }
}

@end
