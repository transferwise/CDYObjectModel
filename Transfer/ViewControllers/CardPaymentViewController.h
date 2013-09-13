//
//  CardPaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;

typedef void (^CardPaymentResultBlock)(BOOL success);

@interface CardPaymentViewController : UIViewController

@property (nonatomic, strong) CardPaymentResultBlock resultHandler;
@property (nonatomic, strong) Payment *payment;

- (void)loadCardView;

@end
