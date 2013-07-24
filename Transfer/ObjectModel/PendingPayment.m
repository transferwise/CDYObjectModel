#import "PendingPayment.h"
#import "MoneyFormatter.h"
#import "_Currency.h"
#import "Currency.h"
#import "CalculationResult.h"


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

@end
