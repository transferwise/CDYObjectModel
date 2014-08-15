//
//  SettingsViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentModalViewController.h"

@class ObjectModel;

@interface SettingsViewController : TransparentModalViewController

@property (nonatomic, strong) ObjectModel *objectModel;

@end
