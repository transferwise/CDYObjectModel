//
//  TargetCountryProvider.h
//  Transfer
//
//  Created by Juhan Hion on 09.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

@interface TargetCountryProvider : NSObject

+ (NSString *)getTargetCountryForCurrency:(Currency *)currency;

@end
