//
//  SettingsButtonCell.h
//  Transfer
//
//  Created by Mats Trovik on 18/05/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsButtonDelegate <NSObject>

-(void)settingsButtonTappedOnCell:(UITableViewCell*)cell;

@end

@interface SettingsButtonCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) id<SettingsButtonDelegate> settingsButtonDelegate;

@end
