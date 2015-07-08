//
//  ApplePayTokenOperation.m
//  Transfer
//
//  Created by Nick Banks on 08/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayOperation.h"

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
+ (ApplePayOperation *) applePayOperationWithParameterDictionary: (NSDictionary *) parameterDictionary;
{
    return [[ApplePayOperation alloc] initWithParameterDictionary: parameterDictionary];
}

/**
 *  Initialiser
 *
 *  @param token Apple Pay token
 *
 *  @return Initialised instance
 */

- (instancetype) initWithParameterDictionary: (NSDictionary *) parameterDictionary
{
    if ((self = [super init]))
    {
        self.parameterDictionary = parameterDictionary;
    }

    return self;
}

- (void) execute
{
    //
    NSString *path = [self addTokenToPath: kApplePayTokenPath];
//    
//    __block __weak typeof(self) *weakSelf = self;
//    
//    [self setOperationSuccessHandler: ^(NSDictionary *response) {
//        weakSelf.responseHandler(nil, response);
//    }];
//    
//    [self setOperationErrorHandler: ^(NSError *error) {
//        MCLog(@"Error:%@", error);
//        weakSelf.responseHandler(error, nil);
//    }];
//    
//    [self postData:params toPath:path];
}


@end






