//
//  PlainCurrency.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainCurrency : NSObject

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSArray *targets;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *defaultRecipientType;
@property (nonatomic, strong, readonly) NSArray *recipientTypes;

- (NSString *)formattedCodeAndName;

+ (PlainCurrency *)currencyWithSourceData:(NSDictionary *)data;
+ (PlainCurrency *)currencyWithCode:(NSString *)code;
+ (PlainCurrency *)currencyWithRecipientData:(NSDictionary *)data;

@end
