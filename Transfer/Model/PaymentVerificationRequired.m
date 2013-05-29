//
//  PaymentVerificationRequired.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentVerificationRequired.h"

@implementation PaymentVerificationRequired

- (BOOL)anyVerificationRequired {
    return self.idVerificationRequired || self.addressVerificationRequired;
}

@end
