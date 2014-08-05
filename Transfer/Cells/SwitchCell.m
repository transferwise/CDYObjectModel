//
//  SwitchCell.m
//  Transfer
//
//  Created by Henri Mägi on 05.08.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SwitchCell.h"
#import "UIColor+MOMStyle.h"

@interface SwitchCell ()

@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end

@implementation SwitchCell

NSString *const TWSwitchCellIdentifier = @"TWSwitchCell";

- (void)awakeFromNib
{
	[self.toggleSwitch setOnTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
}

- (BOOL)value
{
	return self.toggleSwitch.on;
}

- (void)setValue:(BOOL)value
{
	self.toggleSwitch.on = value;
}

@end
