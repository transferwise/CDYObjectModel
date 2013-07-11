//
//  PlainRecipientTypeField.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainRecipientTypeField.h"
#import "PlainStringValue.h"

@interface PlainRecipientTypeField ()

@end

@implementation PlainRecipientTypeField

+ (PlainRecipientTypeField *)fieldWithData:(NSDictionary *)data {
    PlainRecipientTypeField *field = [[PlainRecipientTypeField alloc] init];
    [field setName:data[@"name"]];
    [field setTitle:data[@"title"]];
    id values = data[@"possibleValues"];
    if (values && [values class] != [NSNull class]) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[values count]];
        for (NSString *value in values) {
            [result addObject:[[PlainStringValue alloc] initWithString:value]];
        }
        [field setPossibleValues:[NSArray arrayWithArray:result]];
    }
    return field;
}

@end
