//
//  CheckPersonalProfileVerificationOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 9/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

typedef void (^VerificationCheckResultBlock)(IdentificationRequired identificationRequired);

@interface CheckPersonalProfileVerificationOperation : TransferwiseOperation

@property (nonatomic, copy) VerificationCheckResultBlock resultHandler;

+ (CheckPersonalProfileVerificationOperation *)operation;

@end
