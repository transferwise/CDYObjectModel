#import "_PendingPayment.h"

@interface PendingPayment : _PendingPayment

- (NSDictionary *)data;
- (BOOL)isAnyVerificationRequired;
- (BOOL)idVerificationRequired;
- (BOOL)addressVerificationRequired;
- (BOOL)paymentPurposeRequired;
- (BOOL)ssnVerificationRequired;
- (void)removePaymentPurposeRequiredMarker;
- (void)removeAddressVerificationRequiredMarker;
- (void)removeIdVerificationRequiredMarker;
- (void)removeSsnRequiredMarker;

- (BOOL)needsToCommitRecipientData;
- (BOOL)needsToCommitRefundRecipientData;

+ (NSString *)idPhotoPath;
+ (void)removePossibleImages;
+ (NSString *)addressPhotoPath;
+ (void)setIdPhoto:(UIImage *)image;
+ (void)setAddressPhoto:(UIImage *)image;
+ (void)removeIdImage;
+ (void)removeAddressImage;
+ (BOOL)isIdVerificationImagePresent;
+ (BOOL)isAddressVerificationImagePresent;

@end
