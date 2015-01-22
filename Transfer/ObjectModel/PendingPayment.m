#import "PendingPayment.h"
#import "_Currency.h"
#import "Currency.h"
#import "NSMutableDictionary+SaneData.h"
#import "Recipient.h"
#import "User.h"
#import "Constants.h"

NSString *kIdVerificationImageName = @"~/Documents/idVerification.jpg";
NSString *kAddressVerificationImageName = @"~/Documents/addressVerification.jpg";

@interface PendingPayment ()

@end

@implementation PendingPayment

- (NSDictionary *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setNotNilValue:self.recipient.remoteId forKey:@"recipientId"];
    [dictionary setNotNilValue:self.sourceCurrency.code forKey:@"sourceCurrency"];
    [dictionary setNotNilValue:self.targetCurrency.code forKey:@"targetCurrency"];
    [dictionary setValue:self.isFixedAmountValue?@"target":@"source" forKey:@"amountCurrency"];
    [dictionary setNotNilValue:self.isFixedAmountValue?self.payOut:self.payIn forKey:@"amount"];
    [dictionary setNotNilValue:self.user.email forKey:@"email"];
    [dictionary setNotNilValue:self.profileUsed forKey:@"profile"];
    [dictionary setNotNilValue:self.paymentReference forKey:@"paymentReference"];
    [dictionary setNotNilValue:self.recipientEmail forKey:@"recipientEmail"];
    if ([self isAnyVerificationRequired] && [self sendVerificationLaterValue]) {
        dictionary[@"verificationProvideLater"] = @"true";
    }
    if (self.refundRecipient && self.isFixedAmountValue) {
        dictionary[@"refundRecipientId"] = self.refundRecipient.remoteId;
    }

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)isAnyVerificationRequired {
    return self.verificiationNeededValue != IdentificationNoneRequired;
}

- (BOOL)needsToCommitRecipientData {
    return self.recipient.remoteIdValue == 0;
}

- (BOOL)needsToCommitRefundRecipientData {
    return self.refundRecipient && self.refundRecipient.remoteIdValue == 0;
}

+ (NSString *)idPhotoPath {
    return [kIdVerificationImageName stringByExpandingTildeInPath];
}

- (BOOL)idVerificationRequired {
	return (self.verificiationNeededValue & IdentificationIdRequired) == IdentificationIdRequired;
}

- (BOOL)addressVerificationRequired {
	return (self.verificiationNeededValue & IdentificationAddressRequired) == IdentificationAddressRequired;
}

- (BOOL)paymentPurposeRequired {
	return (self.verificiationNeededValue & IdentificationPaymentPurposeRequired) == IdentificationPaymentPurposeRequired;
}

- (BOOL)ssnVerificationRequired {
	return (self.verificiationNeededValue & IdentificationSSNRequired) == IdentificationSSNRequired;
}

+ (NSString *)addressPhotoPath {
    return [kAddressVerificationImageName stringByExpandingTildeInPath];
}

- (void)removePaymentPurposeRequiredMarker {
	[self setVerificationMarkerWithId:self.idVerificationRequired address:self.addressVerificationRequired paymentPurpose:NO ssn:self.ssnVerificationRequired];
}

- (void)removeAddressVerificationRequiredMarker {
	[self setVerificationMarkerWithId:self.idVerificationRequired address:NO paymentPurpose:self.paymentPurposeRequired ssn:self.ssnVerificationRequired];
}

- (void)removeIdVerificationRequiredMarker {
	[self setVerificationMarkerWithId:NO address:self.addressVerificationRequired paymentPurpose:self.paymentPurposeRequired ssn:self.ssnVerificationRequired];
}

- (void)removeSsnRequiredMarker {
	[self setVerificationMarkerWithId:self.idVerificationRequired address:self.addressVerificationRequired paymentPurpose:self.paymentPurposeRequired ssn:NO];
}

- (void)setVerificationMarkerWithId:(BOOL)idVerification address:(BOOL)addressVerification paymentPurpose:(BOOL)purposeVerification ssn:(BOOL)ssnVerification {
	IdentificationRequired identification = IdentificationNoneRequired;
	if (idVerification) {
		identification = identification | IdentificationIdRequired;
	}
	if (addressVerification) {
		identification = identification | IdentificationAddressRequired;
	}
	if (purposeVerification) {
		identification = identification | IdentificationPaymentPurposeRequired;
	}
    if (ssnVerification) {
		identification = identification | IdentificationSSNRequired;
	}
	[self setVerificiationNeededValue:identification];
}

+ (void)removePossibleImages {
    MCLog(@"removePossibleImages");
    [[NSFileManager defaultManager] removeItemAtPath:[kIdVerificationImageName stringByExpandingTildeInPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath] error:nil];
}

+ (void)removeIdImage {
    MCLog(@"removeIdImages");
    [[NSFileManager defaultManager] removeItemAtPath:[kIdVerificationImageName stringByExpandingTildeInPath] error:nil];
}

+ (void)removeAddressImage {
    MCLog(@"removeAddressImages");
    [[NSFileManager defaultManager] removeItemAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath] error:nil];
}

+ (void)setIdPhoto:(UIImage *)image {
    [self saveImage:image toPath:kIdVerificationImageName];
}

+ (void)setAddressPhoto:(UIImage *)image {
    [self saveImage:image toPath:kAddressVerificationImageName];
}

+ (void)saveImage:(UIImage *)image toPath:(NSString *)path {
    MCLog(@"Save image %@ to path:%@", image, [path stringByExpandingTildeInPath]);
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    MCLog(@"ImageData:%lu", (unsigned long)[imageData length]);
    [imageData writeToFile:[path stringByExpandingTildeInPath] atomically:NO];
}

+ (BOOL)isIdVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kIdVerificationImageName stringByExpandingTildeInPath]];
}

+ (BOOL)isAddressVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath]];
}

@end
