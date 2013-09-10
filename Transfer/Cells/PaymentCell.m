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
#import "UIColor+Theme.h"
#import "Constants.h"

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

    [self.nameLabel setTextColor:HEXCOLOR(0x003B5AFF)];
    [self.moneyLabel setTextColor:HEXCOLOR(0x003B5AFF)];

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

    if ([payment isCancelled] || [payment moneyTransferred]) {
        [self.backgroundView setBackgroundColor:[UIColor controllerBackgroundColor]];
    } else {
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
