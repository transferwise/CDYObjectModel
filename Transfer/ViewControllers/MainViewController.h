//
//  MainViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;

@interface MainViewController : UINavigationController

@property (nonatomic, strong) ObjectModel *objectModel;

-(BOOL)handleDeeplink:(NSURL *)deepLink;

@end
