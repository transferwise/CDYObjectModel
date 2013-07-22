#import "_Payment.h"

@interface Payment : _Payment

- (NSString *)localizedStatus;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;

@end
