//
//  RecipientTypeField.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientTypeField.h"
#import "StringValue.h"

@interface RecipientTypeField ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *possibleValues;

@end

@implementation RecipientTypeField

+ (RecipientTypeField *)fieldWithData:(NSDictionary *)data {
    RecipientTypeField *field = [[RecipientTypeField alloc] init];
    [field setName:data[@"name"]];
    [field setTitle:data[@"title"]];
    id values = data[@"possibleValues"];
    if (values && [values class] != [NSNull class]) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[values count]];
        for (NSString *value in values) {
            [result addObject:[[StringValue alloc] initWithString:value]];
        }
        [field setPossibleValues:[NSArray arrayWithArray:result]];
    }
    return field;
}

@end
