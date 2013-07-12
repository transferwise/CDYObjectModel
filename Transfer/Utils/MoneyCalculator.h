//
//  MoneyCalculator.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalculationResult;

typedef void (^MoneyCalculationHandler)(CalculationResult *result, NSError *error);

@class MoneyEntryCell;
@class ObjectModel;

@interface MoneyCalculator : NSObject

@property (nonatomic, strong) MoneyEntryCell *sendCell;
@property (nonatomic, strong) MoneyEntryCell *receiveCell;
@property (nonatomic, copy) MoneyCalculationHandler calculationHandler;
@property (nonatomic, strong) ObjectModel *objectModel;

- (void)forceCalculate;

@end
