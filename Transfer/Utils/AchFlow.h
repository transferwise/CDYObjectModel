//
//  AchFlow.h
//  Transfer
//
//  Created by Juhan Hion on 20.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRWProgressHUD.h"
#import "TransparentModalViewController.h"

typedef void (^GetLoginFormBlock)(NSString* accountNumber, NSString* routingNumber, UINavigationController *controller);
typedef void (^InitiatePullBlock)(UINavigationController* controller);

@class Payment;
@class ObjectModel;

@interface AchFlow : NSObject<TransparentModalViewControllerDelegate>

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));

+ (AchFlow *)sharedInstanceWithPayment:(Payment *)payment
						   objectModel:(ObjectModel *)objectModel;

- (UIViewController *)getAccountAndRoutingNumberController;

@end
