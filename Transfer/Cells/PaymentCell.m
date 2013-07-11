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

@interface PaymentCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@end

@implementation PaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.statusLabel setTextColor:[UIColor grayColor]];
    [self.timeLabel setTextColor:[UIColor grayColor]];
}


- (void)configureWithPayment:(Payment *)payment {
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.timeLabel setText:[payment latestChangeTimeString]];

    CGRect moneyFrame = self.moneyLabel.frame;
    CGSize moneySize = [self.moneyLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetWidth(moneyFrame))];
    CGFloat widthChange = moneySize.width - CGRectGetWidth(moneyFrame);
    moneyFrame.origin.x -= widthChange;
    moneyFrame.size.width += widthChange;
    [self.moneyLabel setFrame:moneyFrame];

    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.size.width -= widthChange;
    [self.nameLabel setFrame:nameFrame];
}

@end
