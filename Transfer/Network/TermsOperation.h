//
//  TermsOperation.h
//  Transfer
//
//  Created by Juhan Hion on 03.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@interface TermsOperation : TransferwiseOperation

@property (nonatomic, copy) void (^completionHandler)(NSError *error, NSDictionary *result);

+ (TermsOperation *)operationWithSourceCurrency:(NSString *)currencyCode
										country:(NSString *)countryCode;


@end
