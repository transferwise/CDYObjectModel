//
//  Recipient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Recipient.h"

@interface Recipient ()

@property (nonatomic, strong) NSNumber *recipientId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *IBAN;
@property (nonatomic, copy) NSString *BIC;
@property (nonatomic, copy) NSString *abartn;
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *usState;
@property (nonatomic, copy) NSString *sortCode;
@property (nonatomic, copy) NSString *swiftCode;
@property (nonatomic, copy) NSString *bankCode;

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

@end
