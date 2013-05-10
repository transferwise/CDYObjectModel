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
@property (nonatomic, copy, readonly) NSString *iban;
@property (nonatomic, copy, readonly) NSString *bic;
@property (nonatomic, strong, readonly) NSNumber *recipientId;
@property (nonatomic, copy, readonly) NSString *accountNumber;
@property (nonatomic, copy, readonly) NSString *sortCode;

+ (Recipient *)recipientWithData:(NSDictionary *)data;

@end
