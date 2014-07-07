//
//  IntroductionViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;
@class Recipient;

@interface NewPaymentViewController : UIViewController

@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL dummyPresentation;

@end