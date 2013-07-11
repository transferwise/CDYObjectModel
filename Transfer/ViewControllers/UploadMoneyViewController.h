//
//  UploadMoneyViewController.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class PlainRecipient;
@class PlainProfileDetails;
@class PlainPayment;
@class ObjectModel;

@interface UploadMoneyViewController : DataEntryViewController

@property (nonatomic, strong) PlainPayment *payment;
@property (nonatomic, strong) PlainProfileDetails *userDetails;
@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
