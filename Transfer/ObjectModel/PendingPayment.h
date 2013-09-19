#import "_PendingPayment.h"

@interface PendingPayment : _PendingPayment

- (NSDictionary *)data;
- (BOOL)isAnyVerificationRequired;
- (BOOL)idVerificationRequired;
- (BOOL)addressVerificationRequired;
- (BOOL)paymentPurposeRequired;
- (void)removePaymentPurposeRequiredMarker;
- (void)removerAddressVerificationRequiredMarker;
- (void)removeIdVerificationRequiredMarker;

+ (NSString *)idPhotoPath;
+ (void)removePossibleImages;
+ (NSString *)addressPhotoPath;
+ (void)setIdPhoto:(UIImage *)image;
+ (void)setAddressPhoto:(UIImage *)image;
+ (BOOL)isIdVerificationImagePresent;
+ (BOOL)isAddressVerificationImagePresent;

@end
