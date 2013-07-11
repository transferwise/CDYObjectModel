//
//  PlainRecipient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainRecipientProfileInput;

@interface PlainRecipient : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *IBAN;
@property (nonatomic, copy) NSString *BIC;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *sortCode;
@property (nonatomic, copy) NSString *usState;
@property (nonatomic, copy) NSString *abartn;
@property (nonatomic, copy) NSString *swiftCode;
@property (nonatomic, copy) NSString *bankCode;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
- (PlainRecipientProfileInput *)profileInput;

+ (PlainRecipient *)recipientWithData:(NSDictionary *)data;

@end
