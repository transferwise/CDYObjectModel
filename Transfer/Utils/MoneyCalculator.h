//
//  MoneyCalculator.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhyAlertView.h"

@class CalculationResult;

typedef void (^MoneyCalculationHandler)(CalculationResult *result, NSError *error);

@class MoneyEntryCell;

@interface MoneyCalculator : NSObject

@property (nonatomic, strong) MoneyEntryCell *sendCell;
@property (nonatomic, strong) MoneyEntryCell *receiveCell;
@property (nonatomic, strong) WhyAlertView *whyMe;
@property (nonatomic, copy) MoneyCalculationHandler calculationHandler;

- (void)forceCalculate;

@end
