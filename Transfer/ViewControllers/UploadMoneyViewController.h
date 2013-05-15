//
//  UploadMoneyViewController.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class Recipient;
@class ProfileDetails;
@class Payment;

@interface UploadMoneyViewController : DataEntryViewController

@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) NSArray *recipientTypes;

@end
