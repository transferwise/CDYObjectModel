//
//  PaymentFlow.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileDetails;
@class Currency;

@interface PaymentFlow : NSObject

@property (nonatomic, strong) Currency *sourceCurrency;
@property (nonatomic, strong) Currency *targetCurrency;

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;

@end
