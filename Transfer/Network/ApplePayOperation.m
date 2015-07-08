//
//  ApplePayTokenOperation.m
//  Transfer
//
//  Created by Nick Banks on 08/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kApplePayTokenPath = @"/adyen/submitApplePayPayment";

@interface ApplePayOperation ()

@property (nonatomic) NSDictionary *parameterDictionary;

@end

@implementation ApplePayOperation

/**
 *  Factory methods
 *
 *  @param token Apple Pay token
 *
 *  @return Instance of operation initialised with Apple Pay token
 */
+ (ApplePayOperation *) applePayOperationWithPaymentId: (NSString *) paymentId
                                              andToken: (NSString *) token
{
    return [[ApplePayOperation alloc] initWithPaymentId: paymentId
                                               andToken: token];
}

/**
 *  Initialiser
 *
 *  @param token Apple Pay token
 *
 *  @return Initialised instance
 */

- (instancetype) initWithPaymentId: (NSString *) paymentId
                          andToken: (NSString *) token
{
    if ((self = [super init]))
    {
        NSDictionary* parameterDictionary = @{@"paymentId" : paymentId,
                                              @"paymentToken" : token};
        
        self.parameterDictionary = parameterDictionary;
    }

    return self;
}

/**
 *  Perform the Post of the token and transactionId
 */
- (void) execute
{
    //
    NSString *path = [self addTokenToPath: kApplePayTokenPath];
    
    __block __weak ApplePayOperation *weakSelf = self;
    
    [self setOperationSuccessHandler: ^(NSDictionary *response) {
        weakSelf.responseHandler(nil, response);
    }];
    
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error:%@", error);
        weakSelf.responseHandler(error, nil);
    }];
    
    [self postData: self.parameterDictionary
            toPath: path];
}


@end






