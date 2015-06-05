//
//  SettingsSwitchCell.m
//  Transfer
//
//  Created by Mats Trovik on 19/05/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "SettingsSwitchCell.h"
#import "MOMStyle.h"

@implementation SettingsSwitchCell

- (void)awakeFromNib {
    [self.settingsSwitch setOnTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
}

- (IBAction)switchToggled:(id)sender {
    if([self.settingsSwitchDelegate respondsToSelector:@selector(settingsSwitchToggledOnCell:newValue:)])
    {
        [self.settingsSwitchDelegate settingsSwitchToggledOnCell:self newValue:self.settingsSwitch.isOn];
    }
}

@end
