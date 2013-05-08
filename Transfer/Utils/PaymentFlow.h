//
//  PaymentFlow.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentFlow : NSObject

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;

@end
