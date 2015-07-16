//
//  PaymentMethodViewControllerFactory.h
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PayInMethod;
@class Payment;
@class ObjectModel;

@interface PaymentMethodViewControllerFactory : NSObject

+(UIViewController*)viewControllerForPayInMethod:(NSString *)method
									  forPayment:(Payment*)payment
									 objectModel:(ObjectModel*)objectModel;

@end
