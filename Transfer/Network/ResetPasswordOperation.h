//
//  ResetPasswordOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ResetResultBlock)(NSError *error);

@interface ResetPasswordOperation : TransferwiseOperation

@property (nonatomic, copy) ResetResultBlock resultHandler;
@property (nonatomic, copy) NSString *email;

@end
