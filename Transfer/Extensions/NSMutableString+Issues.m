//
//  NSMutableString+Issues.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSMutableString+Issues.h"

@implementation NSMutableString (Issues)

- (void)appendIssue:(NSString *)issue {
    if ([self length] > 0) {
        [self appendString:@"\n"];
    }

    [self appendFormat:@"- %@", issue];
}

@end
