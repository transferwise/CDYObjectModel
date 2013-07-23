//
//  PlainRecipientType.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainRecipientType.h"

@interface PlainRecipientType ()

@end

@implementation PlainRecipientType

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"type = %@, fields %d", self.type, [self.fields count]];
    [description appendString:@">"];
    return description;
}

@end
