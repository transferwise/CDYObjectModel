//
//  PaymentVerificationRequired.h
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentVerificationRequired : NSObject

@property (nonatomic, assign) BOOL idVerificationRequired;
@property (nonatomic, assign) BOOL addressVerificationRequired;

- (BOOL)anyVerificationRequired;
- (void)removePossibleImages;
- (void)setIdPhoto:(UIImage *)image;
- (void)setAddressPhoto:(UIImage *)image;

@end
