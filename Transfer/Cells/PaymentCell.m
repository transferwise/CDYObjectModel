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
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@end

@implementation PaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)configureWithPayment:(Payment *)payment {
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.currencyLabel setText:[payment transferredCurrenciesString]];

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
