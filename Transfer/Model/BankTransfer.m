//
//  BankTransfer.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BankTransfer.h"

@interface BankTransfer ()

@property (strong, nonatomic) NSString *paymentId;
@property (strong, nonatomic) NSNumber* amount;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) Recipient *settlementAccount;

@end

@implementation BankTransfer

+(BankTransfer *)transferWithData:(NSDictionary *)data
{
    BankTransfer *transfer = [[BankTransfer alloc]init];
    NSNumberFormatter *formatter = [BankTransfer moneyFormatter];
    [transfer setPaymentId:data[@"payment_id"]];
    [transfer setAmount:[formatter numberFromString:data[@"amount"]]];
    [transfer setCurrency:data[@"currency"]];
    
    [transfer setSettlementAccount:[Recipient recipientWithData:data[@"settlementAccount"]]];
    
    
    //TODO: bankName + reference

    return transfer;
}

- (NSString *)formattedAmount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[BankTransfer defaultLocale]];
    [formatter setCurrencySymbol:[[BankTransfer defaultLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.currency]];
    return [formatter stringFromNumber:self.amount];
}

+ (NSLocale *)defaultLocale {
    return [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
}

static NSNumberFormatter *__moneyFormatter;
+ (NSNumberFormatter *)moneyFormatter {
    if (!__moneyFormatter) {
        __moneyFormatter = [[NSNumberFormatter alloc] init];
        //TODO jaanus: check this. Needed because actual user locale may require numbers containing ',' instead of '.'
        [__moneyFormatter setLocale:[BankTransfer defaultLocale]];
        [__moneyFormatter setGeneratesDecimalNumbers:YES];
    }
    
    return __moneyFormatter;
}

@end
