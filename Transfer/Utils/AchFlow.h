//
//  AchFlow.h
//  Transfer
//
//  Created by Juhan Hion on 20.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransparentModalViewController.h"

@class Payment;
@class ObjectModel;

typedef void (^GetLoginFormBlock)(NSString *accountNumber, NSString *routingNumber, UINavigationController *controller);
typedef void (^InitiatePullBlock)(NSDictionary *from, UINavigationController *controller);

@interface AchFlow : NSObject<TransparentModalViewControllerDelegate>

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));

+ (AchFlow *)sharedInstanceWithPayment:(Payment *)payment
						   objectModel:(ObjectModel *)objectModel;

- (UIViewController *)getAccountAndRoutingNumberController;

@end
