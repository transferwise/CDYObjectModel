#import "_PendingPayment.h"

@interface PendingPayment : _PendingPayment

- (BOOL)businessProfileUsed;
- (NSString *)payInStringWithCurrency;
- (NSString *)payOutStringWithCurrency;
- (NSString *)rateString;
- (NSString *)paymentDateString;

@end
