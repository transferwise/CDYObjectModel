//
//  SettingsSwitchCell.h
//  Transfer
//
//  Created by Mats Trovik on 19/05/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsSwitchDelegate <NSObject>

-(void)settingsSwitchToggledOnCell:(UITableViewCell*)cell newValue:(BOOL)newValue;

@end

@interface SettingsSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id<SettingsSwitchDelegate> settingsSwitchDelegate;

@end
