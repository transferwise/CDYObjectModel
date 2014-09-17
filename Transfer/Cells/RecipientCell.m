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
#import "Currency.h"
#import "UIColor+MOMStyle.h"
#import "UIImage+Color.h"
#import "AddressBookManager.h"

#define UK_SORT	@"UK Sort code"
#define IBAN	@"IBAN"

@interface RecipientCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;

@property (strong, nonatomic) IBOutlet UIImageView *recipientImage;
@property (strong, nonatomic) IBOutlet UILabel *initialsLabel;

@end

@implementation RecipientCell

- (void)configureWithRecipient:(Recipient *)recipient
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
    [self.bankLabel setText:[NSString stringWithFormat:@"%@ account",[recipient.currency code]]];
	[self.sendLabel setText:[NSString stringWithFormat:NSLocalizedString(@"contacts.controller.send.button.title", nil), recipient.currency.code]];
	
	if (recipient.image)
	{
		self.recipientImage.image = recipient.image;
	}
	else
	{
		[self.recipientImage setImage:[self getRecipientImage:recipient]];
	}
	
	[self maskRecipientImage];
	
	self.canBeCancelled = YES;
	self.cancelButtonTitle = NSLocalizedString(@"contacts.controller.delete.button.title", nil);
}


- (UIImage *)getRecipientImage:(Recipient *)recipient
{
    [[AddressBookManager sharedInstance] getImageForEmail:recipient.email
											requestAccess:NO
											   completion:^(UIImage *image) {
        if(image)
        {
			recipient.image = image;
            self.recipientImage.image = image;
			self.initialsLabel.hidden = YES;
        }
    }];
    self.initialsLabel.hidden = NO;
    self.initialsLabel.text = [self getInitials:[recipient name]];
    return [UIImage imageFromColor:[UIColor colorFromStyle:@"LightBlue"]];
	
}

- (NSString *)getInitials:(NSString *)name
{
	if (name)
	{
		NSArray *components = [name componentsSeparatedByString:@" "];
		
		if (components.count < 1)
		{
			return nil;
		}
		else if (components.count == 1)
		{
			return [self getFirstChar:[components firstObject]];
		}
		else
		{
			return [NSString stringWithFormat:@"%@%@",
				[self getFirstChar:[components firstObject]],
				[self getFirstChar:[components lastObject]]];
		}
	}
	
	return nil;
}


- (NSString *)getFirstChar:(id)input
{
	NSString* str = (NSString *)input;
	
	if (str && str.length > 0)
	{
		return [[str substringToIndex:1] uppercaseString];
	}
	else
	{
		return @"";
	}
}

- (void)maskRecipientImage
{
	self.recipientImage.layer.cornerRadius = 20;
	self.recipientImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.slidingContentView.bgStyle = selected ? @"LightBlueHighlighted" : @"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.slidingContentView.bgStyle = highlighted ? @"LightBlueHighlighted" : @"white";
}

@end
