//
//  LoginOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"

typedef void (^LoginResponseBlock)(NSError *error, NSDictionary *result);

@interface LoginOperation : TransferwiseOperation

@property (nonatomic, copy) LoginResponseBlock responseHandler;

+ (LoginOperation *)loginOperationWithEmail:(NSString *)email
								   password:(NSString *)password
						 keepPendingPayment:(BOOL)keepPendingPayment ;

@end
