//
//  TransferDetialsHeaderView.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetialsHeaderView.h"
#import "UIFont+MOMStyle.h"

@interface TransferDetialsHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel* yourTransferLabel;
@property (weak, nonatomic) IBOutlet UILabel* transferNrLabel;
@property (weak, nonatomic) IBOutlet UILabel* recipientNameLabel;

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
	//to in the beginning must not be bold
	NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.recipient", nil), recipientName] attributes:@{NSFontAttributeName: [UIFont fontFromStyle:@"H4Bold"]}];
	NSDictionary* subAttrs = @{NSFontAttributeName: [UIFont fontFromStyle:@"H4.darkGray"]};
	//an assumption here that "to" will always be 2-3 symbols, should revisit when localizing to other langs
	[attributedName setAttributes:subAttrs range:NSMakeRange(0, 3)];
	
	[self.recipientNameLabel setAttributedText:attributedName];
}

@end
