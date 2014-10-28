//
//  CardPaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;
@class ObjectModel;

typedef void (^CardPaymentResultBlock)(BOOL success);

typedef enum
{
    URLActionContinueLoad,
    URLActionAbortLoad,
    URLActionAbortAndReportSuccess,
    URLActionAbortAndReportFailure
} URLAction;

typedef URLAction (^ShouldLoadURLBlock)(NSURL *url);

@interface CardPaymentViewController : UIViewController

@property (nonatomic, copy) CardPaymentResultBlock resultHandler;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) ShouldLoadURLBlock loadURLBlock;

- (void)loadCardView;

@end
