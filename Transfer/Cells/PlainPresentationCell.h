//
//  BankTransferDetailCell.h
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationCell.h"

#define PlainPresentationCellIdentifier @"PlainPresentationCell"

@interface PlainPresentationCell : PresentationCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (void)configureWithTitle:(NSString *)title text:(NSString *)text;

@end
