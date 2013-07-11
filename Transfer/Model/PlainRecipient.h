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

@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *currency;
@property (nonatomic, copy, readonly) NSString *IBAN;
@property (nonatomic, copy, readonly) NSString *BIC;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *accountNumber;
@property (nonatomic, copy, readonly) NSString *sortCode;
@property (nonatomic, copy, readonly) NSString *usState;
@property (nonatomic, copy, readonly) NSString *abartn;
@property (nonatomic, copy, readonly) NSString *swiftCode;
@property (nonatomic, copy, readonly) NSString *bankCode;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
- (PlainRecipientProfileInput *)profileInput;

+ (PlainRecipient *)recipientWithData:(NSDictionary *)data;

@end
