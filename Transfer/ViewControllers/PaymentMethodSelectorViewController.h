//
//  PaymentMethodSelectorViewController.h
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;
@class ObjectModel;


@interface PaymentMethodSelectorViewController : UIViewController

@property (nonatomic, strong) Payment* payment;
@property (nonatomic, strong) ObjectModel* objectModel;

@end
