//
//  PaymentInput.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentInput.h"

@implementation PaymentInput

- (NSDictionary *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self appendData:@"recipientId" data:dictionary];
    [self appendData:@"sourceCurrency" data:dictionary];
    [self appendData:@"targetCurrency" data:dictionary];
    [self appendData:@"amount" data:dictionary];
    [self appendData:@"reference" data:dictionary];
    [self appendData:@"email" data:dictionary];
    [self appendData:@"verificationProvideLater" data:dictionary];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)appendData:(NSString *)key data:(NSMutableDictionary *)data {
    id value = [self valueForKeyPath:key];
    if (!value) {
        return;
    }

    data[key] = value;
}

@end
