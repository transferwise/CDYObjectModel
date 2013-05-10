//
//  ConfirmPaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class ProfileDetails;
@class Recipient;
@class RecipientType;

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, strong) ProfileDetails *senderDetails;
@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, copy) NSString *footerButtonTitle;

@end
