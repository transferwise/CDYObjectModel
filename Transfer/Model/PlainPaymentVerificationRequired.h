//
//  PlainPaymentVerificationRequired.h
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainPaymentVerificationRequired : NSObject

@property (nonatomic, assign) BOOL idVerificationRequired;
@property (nonatomic, assign) BOOL addressVerificationRequired;
@property (nonatomic, assign) BOOL sendLater;

- (BOOL)isAnyVerificationRequired;
- (void)removePossibleImages;
- (void)setIdPhoto:(UIImage *)image;
- (void)setAddressPhoto:(UIImage *)image;
- (BOOL)isIdVerificationImagePresent;
- (BOOL)isAddressVerificationImagePresent;
- (NSString *)idPhotoPath;
- (NSString *)addressPhotoPath;

@end
