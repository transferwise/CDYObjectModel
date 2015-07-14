//
//  UIViewController+SortedPayInMethods.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;

@interface UIViewController (SortedPayInMethods)

- (NSMutableArray *)sortedPayInMethodTypesForPayment:(Payment *)payment;

@end
