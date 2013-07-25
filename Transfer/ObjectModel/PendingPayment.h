#import "_PendingPayment.h"

@interface PendingPayment : _PendingPayment

- (BOOL)businessProfileUsed;
- (NSString *)payInStringWithCurrency;
- (NSString *)payOutStringWithCurrency;
- (NSString *)rateString;
- (NSString *)paymentDateString;
- (NSDictionary *)data;
- (BOOL)isAnyVerificationRequired;

+ (NSString *)idPhotoPath;
+ (NSString *)addressPhotoPath;
+ (void)removePossibleImages;
+ (void)setIdPhoto:(UIImage *)image;
+ (void)setAddressPhoto:(UIImage *)image;
+ (BOOL)isIdVerificationImagePresent;
+ (BOOL)isAddressVerificationImagePresent;

@end
