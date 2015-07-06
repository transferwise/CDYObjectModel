#import "_Payment.h"


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
- (NSOrderedSet*)enabledPayInMethods;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;
- (NSString *)payInString;
- (NSString *)payInStringNoSpaces;
- (NSString *)payOutString;
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
- (NSString*)paymentStatusString;

-(NSDictionary*)trackingProperties;

@end
