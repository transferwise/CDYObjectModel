//
//  AchDetailsViewController.h
//  Transfer
//
//  Created by Juhan Hion on 18.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

@class Payment;
@class ObjectModel;

#import <UIKit/UIKit.h>
#import "DismissKeyboardViewController.h"

@interface AchDetailsViewController : DismissKeyboardViewController<UITextFieldDelegate>

- (id)init __attribute__((unavailable("init unavailable, use initWithPayment:objectModel.")));
- (instancetype)initWithPayment:(Payment *)payment
					objectModel:(ObjectModel *)objectModel;

@end
