//
//  CheckPersonalProfileVerificationOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 9/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^VerificationCheckResutBlock)(BOOL somethingNeeded);

@interface CheckPersonalProfileVerificationOperation : TransferwiseOperation

@property (nonatomic, copy) VerificationCheckResutBlock resultHandler;

+ (CheckPersonalProfileVerificationOperation *)operation;

@end
