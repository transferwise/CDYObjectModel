//
//  TransferDetailsViewController.h
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@interface TransferDetailsViewController : UIViewController

- (void)configureWithPayment:(Payment *)payment;

@end
