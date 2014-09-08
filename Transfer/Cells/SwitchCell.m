//
//  SwitchCell.m
//  Transfer
//
//  Created by Henri Mägi on 05.08.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SwitchCell.h"
#import "UIColor+MOMStyle.h"
#import "Constants.h"

@interface SwitchCell ()

@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backgroundLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backgroundTrailing;

@end

@implementation SwitchCell

NSString *const TWSwitchCellIdentifier = @"TWSwitchCell";

- (void)awakeFromNib
{
	[self.toggleSwitch setOnTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
	
	if(IPAD)
	{
		self.backgroundLeading.constant = 20 / [UIScreen mainScreen].scale;
		self.backgroundTrailing.constant = 5;
	}
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
