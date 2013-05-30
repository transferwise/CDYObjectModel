//
//  PaymentVerificationRequired.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentVerificationRequired.h"
#import "Constants.h"

NSString *kIdVerificationImageName = @"~/Documents/idVerification.jpg";
NSString *kAddressVerificationImageName = @"~/Documents/addressVerification.jpg";

@implementation PaymentVerificationRequired

- (BOOL)isAnyVerificationRequired {
    return self.idVerificationRequired || self.addressVerificationRequired;
}

- (void)removePossibleImages {
    MCLog(@"removePossibleImages");
    [[NSFileManager defaultManager] removeItemAtPath:[kIdVerificationImageName stringByExpandingTildeInPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath] error:nil];
}

- (void)setIdPhoto:(UIImage *)image {
    [self saveImage:image toPath:kIdVerificationImageName];
}

- (void)setAddressPhoto:(UIImage *)image {
    [self saveImage:image toPath:kAddressVerificationImageName];
}

- (void)saveImage:(UIImage *)image toPath:(NSString *)path {
    MCLog(@"Save image %@ to path:%@", image, [path stringByExpandingTildeInPath]);
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    MCLog(@"ImageData:%d", [imageData length]);
    [imageData writeToFile:[path stringByExpandingTildeInPath] atomically:NO];
}

- (BOOL)isIdVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kIdVerificationImageName stringByExpandingTildeInPath]];
}

- (BOOL)isAddressVerificationImagePresent {
    return [[NSFileManager defaultManager] fileExistsAtPath:[kAddressVerificationImageName stringByExpandingTildeInPath]];
}

- (NSString *)idPhotoPath {
    return [kIdVerificationImageName stringByExpandingTildeInPath];
}

- (NSString *)addressPhotoPath {
    return [kAddressVerificationImageName stringByExpandingTildeInPath];
}

@end
