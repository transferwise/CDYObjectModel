//
//  TermsOperation.h
//  Transfer
//
//  Created by Juhan Hion on 03.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@interface TermsOperation : TransferwiseOperation

+ (TermsOperation *)operationWithSourceCurrency:(NSString *)currencyCode
										country:(NSString *)countryCode
							  completionHandler:(void (^)(NSError *error, NSDictionary *result))completionHandler;

@end
