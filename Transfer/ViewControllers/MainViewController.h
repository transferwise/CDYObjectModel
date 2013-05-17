//
//  MainViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@class ObjectModel;

@interface MainViewController : UINavigationController <SWRevealViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
