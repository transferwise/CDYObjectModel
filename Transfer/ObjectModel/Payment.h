#import "_Payment.h"

typedef NS_OPTIONS(short, PaymentMethod) {
    PaymentNone = 0,
    PaymentRegular = 1 << 0,
    PaymentCard = 1 << 1
};

@interface Payment : _Payment

- (NSString *)localizedStatus;
+ (PaymentMethod)methodsWithData:(NSArray *)methods;
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

@end
