//
//  CustomInfoViewController+UpdatePaymentDetails.h
//  Transfer
//
//  Created by Mats Trovik on 10/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"
@class Payment;
@class ObjectModel;

@interface CustomInfoViewController (UpdatePaymentDetails)

+ (void) presentCustomInfoWithSuccess: (BOOL) success
                           controller: (UIViewController *) controller
                           messageKey: (NSString *) messageKey
                              payment: (Payment*) payment
                          objectModel: (ObjectModel*) objectModel;

@end
