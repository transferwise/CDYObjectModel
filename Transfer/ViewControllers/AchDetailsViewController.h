//
//  AchDetailsViewController.h
//  Transfer
//
//  Created by Juhan Hion on 18.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissKeyboardViewController.h"
#import "AchFlow.h"

@class Payment;
@class ObjectModel;

@interface AchDetailsViewController : DismissKeyboardViewController<UITextFieldDelegate>

- (id)init __attribute__((unavailable("init unavailable, use initWithPayment:objectModel.")));
- (instancetype)initWithPayment:(Payment *)payment
				 loginFormBlock:(GetLoginFormBlock)loginFormBlock;

@end
