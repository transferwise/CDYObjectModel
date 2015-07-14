//
//  ApplePayFlow.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Payment;
@class ObjectModel;

@interface ApplePayFlow : NSObject

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));
+ (ApplePayFlow *)sharedInstanceWithPayment:(Payment *)payment
								objectModel:(ObjectModel *)objectModel
							 successHandler:(TRWActionBlock)successHandler
					  hostingViewController:(UIViewController *)hostingViewController;
- (void)handleApplePay;

@end
