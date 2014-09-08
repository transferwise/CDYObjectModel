//
//  BankTransferDetailCell.h
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PlainPresentationCellIdentifier @"PlainPresentationCell"

@interface PlainPresentationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (void)configureWithTitle:(NSString *)title text:(NSString *)text;

@end
