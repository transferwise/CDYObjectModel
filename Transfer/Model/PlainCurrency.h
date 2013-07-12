//
//  PlainCurrency.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainCurrency : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray *targets;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *defaultRecipientType;
@property (nonatomic, strong) NSArray *recipientTypes;

- (NSString *)formattedCodeAndName;

+ (PlainCurrency *)currencyWithSourceData:(NSDictionary *)data;
+ (PlainCurrency *)currencyWithCode:(NSString *)code;
+ (PlainCurrency *)currencyWithRecipientData:(NSDictionary *)data;

@end
