//
//  RecipientCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientCell.h"
#import "UIColor+Theme.h"
#import "Recipient.h"
#import "UIView+MOMStyle.h"

#define UK_SORT	@"UK Sort code"
#define IBAN	@"IBAN"

@interface RecipientCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;

@end

@implementation RecipientCell

- (void)configureWithPayment:(Recipient *)recipient
		 willShowCancelBlock:(TRWActionBlock)willShowCancelBlock
		  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
		  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock;
{
	//configure swipe to cancel
	[super configureWithWillShowCancelBlock:willShowCancelBlock
						 didShowCancelBlock:didShowCancelBlock
						 didHideCancelBlock:didHideCancelBlock
						  cancelTappedBlock:cancelTappedBlock];
	
    [self.nameLabel setText:[recipient name]];
    [self.bankLabel setText:[self getSortCodeOrIban:recipient]];
}

//this is a temporary solution before bank info becomes available
- (NSString *)getSortCodeOrIban:(Recipient *)recipient
{
	NSString* details = [recipient presentationStringFromAllValues];
	
	if([details rangeOfString:UK_SORT].location != NSNotFound)
	{
		return @"UK Sort Code";
	}
	else if([details rangeOfString:IBAN].location != NSNotFound)
	{
		return @"IBAN";
	}
	return @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.contentView.bgStyle = selected ? @"LightBlueHighlighted" : @"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.bgStyle = highlighted ? @"LightBlueHighlighted" : @"white";
}

@end
