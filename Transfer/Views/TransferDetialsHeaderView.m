//
//  TransferDetialsHeaderView.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetialsHeaderView.h"
#import "UIFont+MOMStyle.h"
#import <OHAttributedLabel.h>
#import "UIFont+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "Constants.h"

@interface TransferDetialsHeaderView ()

@property (strong, nonatomic) IBOutlet UILabel* yourTransferLabel;
@property (strong, nonatomic) IBOutlet UILabel* transferNrLabel;
@property (strong, nonatomic) IBOutlet OHAttributedLabel* recipientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* statusLabel;

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
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:key, recipientName]];
	
    OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.textAlignment = kCTTextAlignmentCenter;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [attributedString setParagraphStyle:paragraphStyle];
	if(IPAD)
	{
		[attributedString setFont:[UIFont fontFromStyle:@"heavy.@20"]];
		[attributedString setFont:[UIFont fontFromStyle:@"medium.@20"] range:toRange];
	}
	else
	{
		[attributedString setFont:[UIFont fontFromStyle:@"heavy.@17"]];
		[attributedString setFont:[UIFont fontFromStyle:@"medium.@17"] range:toRange];
	}
    [attributedString setTextColor:[UIColor colorFromStyle:@"darkGray"]];
	
	[self.recipientNameLabel setAttributedText:attributedString];
}

- (void)setStatus:(NSString *)status
{
	//status is already localized in payment object
	[self.statusLabel setText:status];
}

@end
