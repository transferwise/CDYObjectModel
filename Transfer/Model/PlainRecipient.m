//
//  PlainRecipient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainRecipient.h"
#import "PlainRecipientProfileInput.h"

@interface PlainRecipient ()

@end

@implementation PlainRecipient

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:self.name];
    [description appendString:@">"];
    return description;
}

- (PlainRecipientProfileInput *)profileInput {
    PlainRecipientProfileInput *input = [[PlainRecipientProfileInput alloc] init];
    [input setId:self.id];
    [input setName:self.name];
    [input setCurrency:self.currency];
    [input setType:self.type];
    [input setIBAN:self.IBAN];
    [input setBIC:self.BIC];
    [input setAbartn:self.abartn];
    [input setAccountNumber:self.accountNumber];
    [input setUsState:self.usState];
    [input setSortCode:self.sortCode];
    [input setSwiftCode:self.swiftCode];
    [input setBankCode:self.bankCode];
    return input;
}

+ (PlainRecipient *)recipientWithData:(NSDictionary *)data {
    if (!data || [data isKindOfClass:[NSNull class]]) {
        return nil;
    }

    PlainRecipient *recipient = [[PlainRecipient alloc] init];
    [recipient setId:data[@"id"]];
    [recipient setName:data[@"name"]];
    [recipient setCurrency:data[@"currency"]];
    [recipient setType:data[@"type"]];
    [recipient setIBAN:data[@"IBAN"]];
    [recipient setBIC:data[@"BIC"]];
    [recipient setAbartn:data[@"abartn"]];
    [recipient setAccountNumber:data[@"accountNumber"]];
    [recipient setUsState:data[@"usState"]];
    [recipient setSortCode:data[@"sortCode"]];
    [recipient setSwiftCode:data[@"swiftCode"]];
    [recipient setBankCode:data[@"bankCode"]];

    return recipient;
}

@end
