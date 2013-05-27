//
//  Recipient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Recipient.h"
#import "MoneyFormatter.h"

@interface Recipient ()

@property (nonatomic, strong) NSNumber *recipientId;

@end

@implementation Recipient

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:self.name];
    [description appendString:@">"];
    return description;
}

- (NSString *)detailsRowOne {
    if ([self.type isEqualToString:@"IBAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.IBAN.base", nil), self.IBAN];
    } else if ([self.type isEqualToString:@"SORT_CODE"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.SORT_CODE.base", nil), self.sortCode];
    } else if ([self.type isEqualToString:@"ABA"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.ABA.base", nil), self.abartn, self.usState];
    } else if ([self.type isEqualToString:@"SWIFT_CODE"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.SWIFT_CODE.base", nil), self.swiftCode];
    } else if ([self.type isEqualToString:@"CANADA"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.bank.code.base", nil), self.bankCode];
    } else if ([self.type isEqualToString:@"SCANDINAVIAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.bank.code.base", nil), self.bankCode];
    } else if ([self.type isEqualToString:@"POLAND"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"LATVIAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.SWIFT_CODE.base", nil), self.swiftCode];
    } else if ([self.type isEqualToString:@"LITHUANIAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    }

    return @"";
}

- (NSString *)detailsRowTwo {
    if ([self.type isEqualToString:@"IBAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.BIC.base", nil), self.BIC];
    } else if ([self.type isEqualToString:@"SORT_CODE"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"ABA"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"SWIFT_CODE"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"CANADA"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"SCANDINAVIAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"POLAND"]) {

    } else if ([self.type isEqualToString:@"LATVIAN"]) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.details.account.number.base", nil), self.accountNumber];
    } else if ([self.type isEqualToString:@"LITHUANIAN"]) {

    }

    return @"";
}

+ (Recipient *)recipientWithData:(NSDictionary *)data {
    if (!data || [data isKindOfClass:[NSNull class]]) {
        return nil;
    }

    Recipient *recipient = [[Recipient alloc] init];
    [recipient setRecipientId:data[@"id"]];
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

- (NSDictionary *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self appendData:@"id" data:dictionary];
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
