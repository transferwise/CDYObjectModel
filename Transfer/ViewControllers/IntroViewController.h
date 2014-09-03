//
//  IntroViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;

@interface IntroViewController : UIViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) NSString *plistFilenameOverride;

@end
