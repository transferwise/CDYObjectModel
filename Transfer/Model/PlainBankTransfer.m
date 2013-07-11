//
//  PlainBankTransfer.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainBankTransfer.h"

@interface PlainBankTransfer ()

@property (strong, nonatomic) NSString *paymentId;
@property (strong, nonatomic) NSNumber* amount;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) PlainRecipient *settlementAccount;

@end

@implementation PlainBankTransfer

+(PlainBankTransfer *)transferWithData:(NSDictionary *)data
{
    PlainBankTransfer *transfer = [[PlainBankTransfer alloc]init];
    NSNumberFormatter *formatter = [PlainBankTransfer moneyFormatter];
    [transfer setPaymentId:data[@"payment_id"]];
    [transfer setAmount:[formatter numberFromString:data[@"amount"]]];
    [transfer setCurrency:data[@"currency"]];
    
    [transfer setSettlementAccount:[PlainRecipient recipientWithData:data[@"settlementAccount"]]];
    
    
    //TODO: bankName + reference

    return transfer;
}

- (NSString *)formattedAmount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[PlainBankTransfer defaultLocale]];
    [formatter setCurrencySymbol:[[PlainBankTransfer defaultLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.currency]];
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
        [__moneyFormatter setLocale:[PlainBankTransfer defaultLocale]];
        [__moneyFormatter setGeneratesDecimalNumbers:YES];
    }
    
    return __moneyFormatter;
}

@end
