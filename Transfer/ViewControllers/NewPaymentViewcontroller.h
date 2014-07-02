//
//  IntroductionViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;

@interface IntroductionViewController : UIViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL dummyPresentation;

@end
