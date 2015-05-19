//
//  SettingsButtonCell.m
//  Transfer
//
//  Created by Mats Trovik on 18/05/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "SettingsButtonCell.h"

@implementation SettingsButtonCell


- (IBAction)settingsButtonTapped:(id)sender {
    if([self.settingsButtonDelegate respondsToSelector:@selector(settingsButtonTappedOnCell:)])
    {
        [self.settingsButtonDelegate settingsButtonTappedOnCell:self];
    }
}

@end
