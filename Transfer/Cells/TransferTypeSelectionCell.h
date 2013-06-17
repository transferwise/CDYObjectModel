//
//  TransferTypeSelectionCell.h
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TWTypeSelectionCellIdentifier;

@interface TransferTypeSelectionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end
