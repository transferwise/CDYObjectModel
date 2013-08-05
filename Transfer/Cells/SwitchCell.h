//
//  SwitchCell.h
//  Transfer
//
//  Created by Henri Mägi on 05.08.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TWSwitchCellIdentifier;

@interface SwitchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end
