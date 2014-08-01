//
//  BankTransferDetailCell.m
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PlainPresentationCell.h"

@implementation PlainPresentationCell

- (void)configureWithTitle:(NSString *)title text:(NSString *)text {
    [self.headerLabel setText:title];
    [self.valueLabel setText:text];
}

@end