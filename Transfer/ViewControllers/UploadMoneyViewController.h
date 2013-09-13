//
//  UploadMoneyViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;
@class ObjectModel;

@interface UploadMoneyViewController : UIViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, assign) BOOL hideBottomButton;
@property (nonatomic, assign) BOOL showContactSupportCell;

@end
