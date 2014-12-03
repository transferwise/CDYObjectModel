//
//  NSError+TRWErrors.m
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSError+TRWErrors.h"
#import "NetworkErrorCodes.h"
#import "NSMutableString+Issues.h"
#import "TransferwiseOperation.h"

@implementation NSError (TRWErrors)

- (BOOL)isTransferwiseError {
    return [TRWErrorDomain isEqualToString:self.domain];

}

- (NSString *)localizedTransferwiseMessage {
    if (self.code != ResponseCumulativeError) {
        NSString *messageKey = [NSString stringWithFormat:@"errors.TRWErrorDomain.%ld.message", (long)self.code];
        NSString *message = NSLocalizedString(messageKey, nil);
        if ([message isEqualToString:messageKey]) {
            return [self localizedDescription];
        }

        return message;
    }

    NSArray *errors = self.userInfo[TRWErrors];
    NSMutableString *errorsString = [NSMutableString string];

    for (NSDictionary *error in errors) {
        NSString *message = error[@"message"];

        if (!message) {
            NSString *code = error[@"code"];
            NSString *messageKey = [NSString stringWithFormat:@"errors.%@.message", code];
            message = NSLocalizedString(messageKey, nil);
        }

        [errorsString appendIssue:message];
    }

    return [NSString stringWithString:errorsString];
}

- (BOOL)twCodeNotFound
{
	return [self containsTwCode:@"NOT_FOUND"];
}

- (BOOL)containsTwCode:(NSString *)expectedCode
{
	NSArray *errors = self.userInfo[TRWErrors];
	for (NSDictionary *error in errors)
	{
		NSString *code = error[@"code"];
		if ([code isEqualToString:expectedCode])
		{
			return YES;
		}
	}
	return NO;
}

@end
