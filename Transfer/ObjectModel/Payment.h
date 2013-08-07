#import "_Payment.h"

@interface Payment : _Payment

- (NSString *)localizedStatus;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;
- (BOOL)isSubmitted;
- (NSString *)payInStringWithCurrency;
- (NSString *)payOutStringWithCurrency;
- (NSString *)rateString;
- (NSString *)paymentDateString;
- (BOOL)businessProfileUsed;
- (BOOL)isCancelled;

@end
