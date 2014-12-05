//
//  TransferDetialsHeaderView.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetialsHeaderView.h"
#import "UIFont+MOMStyle.h"
#import "UIFont+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "Constants.h"

@interface TransferDetialsHeaderView ()

@property (strong, nonatomic) IBOutlet UILabel* yourTransferLabel;
@property (strong, nonatomic) IBOutlet UILabel* transferNrLabel;
@property (strong, nonatomic) IBOutlet UILabel* recipientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* statusLabel;
@property (strong, nonatomic) IBOutlet UILabel* statusLabelWaiting;

@end

@implementation TransferDetialsHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self.yourTransferLabel setText:NSLocalizedString(@"transferdetails.controller.transfer.header" , nil)];
}

- (void)setTransferNumber:(NSString *)transferNumber
{
	[self.transferNrLabel setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.number", nil), transferNumber]];
}

- (void)setRecipientName:(NSString *)recipientName
{
	NSString *key = NSLocalizedString(@"transferdetails.controller.transfer.recipient", nil);
	//last two symbols of the key are %@
	NSRange toRange = NSMakeRange(0, key.length - 2);
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:key, recipientName]
																						 attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
	
	if(IPAD)
	{
		[attributedString addAttribute:NSFontAttributeName
								 value:[UIFont fontFromStyle:@"heavy.@20"]
								 range:NSMakeRange(toRange.location, attributedString.length)];
		[attributedString addAttribute:NSFontAttributeName
								 value:[UIFont fontFromStyle:@"medium.@20"]
								 range:toRange];
	}
	else
	{
		[attributedString addAttribute:NSFontAttributeName
								 value:[UIFont fontFromStyle:@"heavy.@17"]
								 range:NSMakeRange(toRange.location, attributedString.length)];
		[attributedString addAttribute:NSFontAttributeName
								 value:[UIFont fontFromStyle:@"medium.@17"]
								 range:toRange];
	}
	
	[attributedString addAttribute:NSForegroundColorAttributeName
							 value:[UIColor colorFromStyle:@"DarkFont"]
							 range:NSMakeRange(0, attributedString.length)];
	
	[self.recipientNameLabel setAttributedText:attributedString];
}

- (void)setStatus:(NSString *)status
{
	//status is already localized in payment object
	[self.statusLabel setText:status];
}

- (void)setStatusWaiting:(NSString *)statusWaiting
{
	//waiting for transfer has a two-line status
	[self.statusLabelWaiting setText:statusWaiting];
}

@end
