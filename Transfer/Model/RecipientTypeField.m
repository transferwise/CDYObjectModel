//
//  RecipientTypeField.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientTypeField.h"

@interface RecipientTypeField ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

@end

@implementation RecipientTypeField

+ (RecipientTypeField *)fieldWithData:(NSDictionary *)data {
    RecipientTypeField *field = [[RecipientTypeField alloc] init];
    [field setName:data[@"name"]];
    [field setTitle:data[@"title"]];
    return field;
}

@end
