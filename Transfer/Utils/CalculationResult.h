//
//  CalculationResult.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculationResult : NSObject

@property (nonatomic, strong, readonly) NSNumber *transferwisePayOut;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;

+ (CalculationResult *)resultWithData:(NSDictionary *)data;

- (NSString *)formattedWinAmount;
+ (NSLocale *)defaultLocale;

@end
