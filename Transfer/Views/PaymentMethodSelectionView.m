//
//  PaymentMethodSelectionView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodSelectionView.h"

@interface PaymentMethodSelectionView ()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;

@end

@implementation PaymentMethodSelectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.messageLabel setText:NSLocalizedString(@"upload.money.header.label", @"")];
}

@end
