//
//  ConfirmPaymentCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ConfirmPaymentCell.h"
#import "UIColor+Theme.h"

NSString *const TWConfirmPaymentCellIdentifier = @"TWConfirmPaymentCellIdentifier";

@implementation ConfirmPaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.textLabel setTextColor:[UIColor disabledEntryTextColor]];
    [self.detailTextLabel setTextColor:[UIColor disabledEntryTextColor]];
}

@end
