//
//  PaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipient;

@interface PaymentViewController : UITableViewController

@property (nonatomic, strong) Recipient *recipient;

@end
