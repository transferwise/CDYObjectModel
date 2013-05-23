//
//  RecipientCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientCell.h"
#import "Recipient.h"
#import "UIColor+Theme.h"

@interface RecipientCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *accountLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalTransferredLabel;

@end

@implementation RecipientCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.accountLabel setTextColor:[UIColor mainTextColor]];
    [self.bankLabel setTextColor:[UIColor mainTextColor]];
}

- (void)configureWithRecipient:(Recipient *)recipient {
    [self.nameLabel setText:[recipient name]];
    [self.accountLabel setText:[recipient detailsRowOne]];
    [self.bankLabel setText:[recipient detailsRowTwo]];
    [self.totalTransferredLabel setText:[recipient totalTransferredString]];

    [self sizeLeftLabel:self.nameLabel rightLabel:self.totalTransferredLabel];
}

- (void)sizeLeftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel {
    CGRect rightFrame = rightLabel.frame;
    CGSize rightSize = [rightLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(rightFrame))];
    CGFloat rightWidthChange = rightSize.width - CGRectGetWidth(rightFrame);
    rightFrame.origin.x -= rightWidthChange;
    rightFrame.size.width += rightWidthChange;
    [rightLabel setFrame:rightFrame];

    CGRect leftFrame = leftLabel.frame;
    leftFrame.size.width -= rightWidthChange;
    [leftLabel setFrame:leftFrame];
}

@end
