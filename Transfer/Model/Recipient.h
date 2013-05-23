//
//  Recipient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipient : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *currency;
@property (nonatomic, copy, readonly) NSString *IBAN;
@property (nonatomic, copy, readonly) NSString *BIC;
@property (nonatomic, strong, readonly) NSNumber *recipientId;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *accountNumber;
@property (nonatomic, copy, readonly) NSString *sortCode;
@property (nonatomic, copy, readonly) NSString *usState;
@property (nonatomic, strong, readonly) NSNumber *totalTransferred;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;

+ (Recipient *)recipientWithData:(NSDictionary *)data;

@end
