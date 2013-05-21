//
//  Recipient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipient : NSObject

@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *IBAN;
@property (nonatomic, copy) NSString *BIC;
@property (nonatomic, copy) NSString *abartn;
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *usState;
@property (nonatomic, copy) NSString *sortCode;
@property (nonatomic, copy) NSString *swiftCode;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *email;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;

+ (Recipient *)recipientWithData:(NSDictionary *)data;
- (NSDictionary *)data;

@end
