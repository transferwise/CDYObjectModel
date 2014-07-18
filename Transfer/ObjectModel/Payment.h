#import "_Payment.h"


@interface Payment : _Payment

- (NSString *)localizedStatus;
- (NSOrderedSet*)enabledPayInMethods;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;
- (BOOL)isSubmitted;
- (NSString *)payInStringWithCurrency;
- (NSString *)payOutStringWithCurrency;
- (NSString *)rateString;
- (NSString *)paymentDateString;
- (NSString *)cancelDateString;
- (BOOL)businessProfileUsed;
- (BOOL)isCancelled;
- (BOOL)moneyReceived;
- (BOOL)moneyTransferred;
- (NSString *)transferredDateString;
- (BOOL)multiplePaymentMethods;

@end
