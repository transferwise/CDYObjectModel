//
//  RecipientProfileInput.m
//  Transfer
//
//  Created by Jaanus Siim on 6/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientProfileInput.h"

@implementation RecipientProfileInput

- (NSDictionary *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self appendData:@"name" data:dictionary];
    [self appendData:@"currency" data:dictionary];
    [self appendData:@"type" data:dictionary];
    [self appendData:@"IBAN" data:dictionary];
    [self appendData:@"BIC" data:dictionary];
    [self appendData:@"abartn" data:dictionary];
    [self appendData:@"accountNumber" data:dictionary];
    [self appendData:@"usState" data:dictionary];
    [self appendData:@"sortCode" data:dictionary];
    [self appendData:@"swiftCode" data:dictionary];
    [self appendData:@"bankCode" data:dictionary];
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
