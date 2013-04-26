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

@implementation NSError (TRWErrors)

- (BOOL)isTransferwiseError {
    if (![TRWErrorDomain isEqualToString:self.domain]) {
        return NO;
    }

    if (!self.userInfo) {
        return NO;
    }

    NSArray *errors = self.userInfo[TRWErrors];
    return [errors count] > 0;
}

- (NSString *)localizedTransferwiseMessage {
    NSArray *errors = self.userInfo[TRWErrors];
    NSMutableString *errorsString = [NSMutableString string];

    for (NSDictionary *error in errors) {
        NSString *code = error[@"code"];
        NSString *messageKey = [NSString stringWithFormat:@"errors.%@.message", code];
        NSString *message = NSLocalizedString(messageKey, nil);
        [errorsString appendIssue:message];
    }

    return [NSString stringWithString:errorsString];
}

@end
