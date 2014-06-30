#import "_Payment.h"

typedef NS_OPTIONS(short, PaymentMethod) {
    PaymentNone = 0,
    PaymentRegular = 1 << 0,
    PaymentCard = 1 << 1
};

typedef NS_ENUM(NSUInteger, PaymentStatus) {
    PaymentStatusUnknown = 0,
    PaymentStatusCancelled,
    PaymentStatusMatched,
    PaymentStatusReceived,
    PaymentStatusRefunded,
    PaymentStatusSubmitted,
    PaymentStatusTransferred,
    PaymentStatusReceivedWaitingRecipient,
    PaymentStatusUserHasPaid //Status when this device has a record of the user having pressed the "I have paid" button.
};

@interface Payment : _Payment

- (PaymentStatus)status;
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
- (BOOL)multiplePaymentMethods;
- (NSString *)transferredCurrenciesString;

@end
