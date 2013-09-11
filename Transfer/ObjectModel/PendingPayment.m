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
    [dictionary setNotNilValue:self.payIn forKey:@"amount"];
    [dictionary setNotNilValue:self.user.email forKey:@"email"];
    //[self appendData:@"verificationProvideLater" data:dictionary];
    [dictionary setNotNilValue:self.profileUsed forKey:@"profile"];
    [dictionary setNotNilValue:self.reference forKey:@"paymentReference"];
    [dictionary setNotNilValue:self.recipientEmail forKey:@"recipientEmail"];
    if ([self isAnyVerificationRequired] && [self sendVerificationLaterValue]) {
        dictionary[@"verificationProvideLater"] = @"true";
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)isAnyVerificationRequired {
    return self.idVerificationRequiredValue || self.addressVerificationRequiredValue || self.paymentPurposeRequiredValue || YES;
}

+ (NSString *)idPhotoPath {
    return [kIdVerificationImageName stringByExpandingTildeInPath];
}

+ (NSString *)addressPhotoPath {
    return [kAddressVerificationImageName stringByExpandingTildeInPath];
}

+ (void)removePossibleImages {
    MCLog(@"removePossibleImages");
    [[NSFileManager defaultManager] removeItemAtPath:[kIdVerificationImageName stringByExpandingTildeInPath] error:nil];
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
    MCLog(@"ImageData:%d", [imageData length]);
    [imageData writeToFile:[path stringByExpandingTildeInPath] atomically:NO];
}

+ (BOOL)isIdVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kIdVerificationImageName stringByExpandingTildeInPath]];
}

+ (BOOL)isAddressVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath]];
}

@end
