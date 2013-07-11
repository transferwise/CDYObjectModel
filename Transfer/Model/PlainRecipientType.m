//
//  PlainRecipientType.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainRecipientType.h"
#import "Constants.h"
#import "PlainRecipientTypeField.h"

@interface PlainRecipientType ()

@end

@implementation PlainRecipientType

+ (PlainRecipientType *)typeWithData:(NSDictionary *)data {
    PlainRecipientType *type = [[PlainRecipientType alloc] init];
    NSString *typeString = data[@"type"];
    [type setType:typeString];
    
    NSArray *fields = data[@"fields"];
    MCLog(@"Type %@ has %d fields", typeString, [data count]);
    NSMutableArray *fieldObjects = [NSMutableArray arrayWithCapacity:[data count]];
    for (NSDictionary *fieldData in fields) {
        PlainRecipientTypeField *field = [PlainRecipientTypeField fieldWithData:fieldData];
        [fieldObjects addObject:field];
    }

    [type setFields:[NSArray arrayWithArray:fieldObjects]];
    
    return type;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"type = %@, fields %d", self.type, [self.fields count]];
    [description appendString:@">"];
    return description;
}

@end
