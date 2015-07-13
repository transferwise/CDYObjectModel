//
//  UploadMoneyViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbedHeaderViewController.h"

@class Payment;
@class ObjectModel;
@class PayInMethod;

@interface UploadMoneyViewController : TabbedHeaderViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) NSString* forcedMethod;
@property (nonatomic, assign) BOOL hideBottomButton;
@property (nonatomic, assign) BOOL showContactSupportCell;

@end
