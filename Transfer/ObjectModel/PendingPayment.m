#import "PendingPayment.h"
#import "MoneyFormatter.h"
#import "_Currency.h"
#import "Currency.h"
#import "CalculationResult.h"
#import "NSMutableDictionary+SaneData.h"
#import "Recipient.h"
#import "User.h"


@interface PendingPayment ()

@end

@implementation PendingPayment

- (BOOL)businessProfileUsed {
    return [self.profileUsed isEqualToString:@"business"];
}

- (NSString *)payInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:[self payIn] withCurrency:self.sourceCurrency.code];
}

- (NSString *)payOutStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.payOut withCurrency:self.targetCurrency.code];
}

- (NSString *)rateString {
    return [CalculationResult rateStringFrom:self.rate];
}

- (NSString *)paymentDateString {
    return [[CalculationResult paymentDateFormatter] stringFromDate:self.estimatedDelivery];
}

- (NSDictionary *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setNotNilValue:self.recipient.remoteId forKey:@"recipientId"];
    [dictionary setNotNilValue:self.sourceCurrency.code forKey:@"sourceCurrency"];
    [dictionary setNotNilValue:self.targetCurrency.code forKey:@"targetCurrency"];
    [dictionary setNotNilValue:self.payIn forKey:@"amount"];
    [dictionary setNotNilValue:self.user.email forKey:@"email"];
    //[self appendData:@"verificationProvideLater" data:dictionary];
    [dictionary setNotNilValue:self.profileUsed forKey:@"profile"];
    [dictionary setNotNilValue:self.reference forKey:@"paymentReference"];
    [dictionary setNotNilValue:self.recipientEmail forKey:@"recipientEmail"];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
