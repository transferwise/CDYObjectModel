//
//  Currency.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

+ (Currency *)currencyWithSourceData:(NSDictionary *)data;

@end
