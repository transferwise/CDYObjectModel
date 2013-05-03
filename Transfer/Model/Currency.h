//
//  Currency.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSArray *targets;

+ (Currency *)currencyWithSourceData:(NSDictionary *)data;
+ (Currency *)currencyWithCode:(NSString *)code;

@end
