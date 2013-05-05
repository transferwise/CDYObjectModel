//
//  Recipient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Recipient.h"

@interface Recipient ()

@property (nonatomic, strong) NSNumber *recipientId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *iban;
@property (nonatomic, copy) NSString *bic;

@end

@implementation Recipient

+ (Recipient *)recipientWithData:(NSDictionary *)data {
    Recipient *recipient = [[Recipient alloc] init];
    [recipient setRecipientId:data[@"id"]];
    [recipient setName:data[@"name"]];
    [recipient setCurrency:data[@"currency"]];
    [recipient setType:data[@"type"]];
    [recipient setIban:data[@"IBAN"]];
    [recipient setBic:data[@"BIC"]];
    return recipient;
}

@end
